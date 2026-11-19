import sqlite3
import os
import webbrowser
import json
from datetime import datetime

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DB_PATH = os.path.join(BASE_DIR, "backend", "presensi.db")
HTML_PATH = os.path.join(BASE_DIR, "DASHBOARD_SANTRI.html")

def fetch_data():
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()

    # 1. Latest Session Info
    cur.execute("""
        SELECT id, activity_name, session_date, session_time, status, capture_count
        FROM sessions 
        ORDER BY id DESC LIMIT 1;
    """)
    latest_session = cur.fetchone()
    latest_session_id = latest_session[0] if latest_session else None

    # Attendance map for latest session
    attendance_map = {}
    if latest_session_id:
        cur.execute("""
            SELECT student_id, status, match_score, method, marked_at
            FROM attendance
            WHERE session_id = ?;
        """, (latest_session_id,))
        for row in cur.fetchall():
            attendance_map[row[0]] = {
                "status": row[1],
                "score": round(row[2] * 100, 1) if row[2] is not None else None,
                "method": row[3],
                "marked_at": row[4]
            }

    # 2. Students & Face Registration Breakdown
    cur.execute("""
        SELECT 
            s.id, s.nim, s.full_name, s.has_faces,
            COUNT(f.id) as pose_count,
            GROUP_CONCAT(f.pose_label, ', ') as poses
        FROM students s
        LEFT JOIN face_embeddings f ON s.id = f.student_id
        GROUP BY s.id
        ORDER BY s.has_faces DESC, s.full_name ASC;
    """)
    students_rows = cur.fetchall()

    students = []
    total_embeddings = 0
    registered_count = 0

    for r in students_rows:
        s_id, nim, name, has_faces, pose_count, poses_str = r
        poses = [p.strip().capitalize() for p in (poses_str.split(',') if poses_str else [])]
        is_registered = bool(has_faces == 1 or pose_count > 0)
        if is_registered:
            registered_count += 1
        total_embeddings += pose_count

        att = attendance_map.get(s_id, {"status": "belum_absen", "score": None, "method": None, "marked_at": None})

        students.append({
            "id": s_id,
            "nim": nim,
            "name": name,
            "is_registered": is_registered,
            "pose_count": pose_count,
            "poses": poses,
            "att_status": att["status"],
            "att_score": att["score"],
            "att_time": att["marked_at"]
        })

    # Stats
    total_students = len(students)
    unregistered_count = total_students - registered_count
    reg_percent = round((registered_count / total_students * 100), 1) if total_students > 0 else 0

    # Count attended in latest session
    attended_count = sum(1 for s in students if s["att_status"] == "hadir")

    conn.close()

    return {
        "students": students,
        "total_students": total_students,
        "registered_count": registered_count,
        "unregistered_count": unregistered_count,
        "reg_percent": reg_percent,
        "total_embeddings": total_embeddings,
        "latest_session": latest_session,
        "attended_count": attended_count
    }

def print_terminal_summary(data):
    print("\n" + "=" * 65)
    print("        ABSAR (أَبْصَار) - MONITOR STATUS REGISTRASI SANTRI")
    print("=" * 65)
    print(f" Total Santri Terdata  : {data['total_students']} Orang")
    print(f" Wajah Terdaftar (Siap): {data['registered_count']} Orang ({data['reg_percent']}%) [HIJAU]")
    print(f" Belum Rekam Wajah     : {data['unregistered_count']} Orang")
    print(f" Total Vektor Pose AI  : {data['total_embeddings']} Pose Wajah")
    if data['latest_session']:
        sess = data['latest_session']
        print(f" Sesi Terakhir         : {sess[1]} ({sess[2]} {sess[3]})")
        print(f" Kehadiran Terdeteksi  : {data['attended_count']} Santri Hadir Otomatis")
    print("=" * 65)

    print("\n[DAFTAR SANTRI SUDAH TERDAFTAR WAJAH]:")
    idx = 1
    for s in data['students']:
        if s['is_registered']:
            poses_desc = ", ".join(s['poses']) if s['poses'] else "Wajah Terdaftar"
            att_tag = f" [Hadir {s['att_score']}%]" if s['att_status'] == 'hadir' else ""
            print(f" {idx:2d}. {s['nim']} - {s['name'][:28]:<28} ({s['pose_count']} pose: {poses_desc}){att_tag}")
            idx += 1

    print("\n[DAFTAR SANTRI BELUM REKAM WAJAH]:")
    idx = 1
    for s in data['students']:
        if not s['is_registered']:
            print(f" {idx:2d}. {s['nim']} - {s['name']}")
            idx += 1

    print("\n" + "=" * 65)
    print(f"Membuka Dashboard Visual di Browser Anda...")
    print(f"Lokasi File: {HTML_PATH}")
    print("=" * 65 + "\n")

def generate_html_dashboard(data):
    students_json = json.dumps(data["students"])
    latest_sess = data["latest_session"]
    sess_text = f"{latest_sess[1]} - {latest_sess[2]} {latest_sess[3]}" if latest_sess else "Belum Ada Sesi"

    html_content = f"""<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard Data Santri & Wajah - ABSAR</title>
  <style>
    :root {{
      --bg: #090d16;
      --card-bg: #111827;
      --card-border: #1f2937;
      --primary: #10b981;
      --primary-glow: rgba(16, 185, 129, 0.2);
      --gold: #f59e0b;
      --gold-glow: rgba(245, 158, 11, 0.2);
      --blue: #3b82f6;
      --text: #f3f4f6;
      --text-muted: #9ca3af;
      --danger: #ef4444;
    }}
    * {{
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    }}
    body {{
      background-color: var(--bg);
      color: var(--text);
      padding: 24px;
      min-height: 100vh;
    }}
    .container {{
      max-width: 1200px;
      margin: 0 auto;
    }}
    /* Header */
    .header {{
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
      gap: 16px;
      padding-bottom: 24px;
      border-bottom: 1px solid var(--card-border);
      margin-bottom: 24px;
    }}
    .title-group h1 {{
      font-size: 26px;
      font-weight: 800;
      letter-spacing: -0.5px;
      display: flex;
      align-items: center;
      gap: 10px;
    }}
    .arabic {{
      color: var(--gold);
      font-size: 30px;
      font-family: 'Amiri', 'Traditional Arabic', serif;
    }}
    .tagline {{
      color: var(--text-muted);
      font-size: 13.5px;
      margin-top: 4px;
    }}
    .header-actions {{
      display: flex;
      gap: 12px;
    }}
    .btn {{
      padding: 10px 18px;
      border-radius: 10px;
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      transition: all 0.2s ease;
      border: 1px solid transparent;
      text-decoration: none;
    }}
    .btn-primary {{
      background: linear-gradient(135deg, #10b981 0%, #059669 100%);
      color: white;
      box-shadow: 0 4px 14px var(--primary-glow);
    }}
    .btn-primary:hover {{
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(16, 185, 129, 0.35);
    }}
    .btn-outline {{
      background: var(--card-bg);
      color: var(--text);
      border-color: var(--card-border);
    }}
    .btn-outline:hover {{
      background: #1f2937;
      border-color: #374151;
    }}

    /* Stat Cards */
    .stats-grid {{
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
      gap: 16px;
      margin-bottom: 24px;
    }}
    .stat-card {{
      background: var(--card-bg);
      border: 1px solid var(--card-border);
      border-radius: 14px;
      padding: 18px;
      position: relative;
      overflow: hidden;
      transition: transform 0.2s ease, border-color 0.2s ease;
    }}
    .stat-card:hover {{
      transform: translateY(-3px);
      border-color: #374151;
    }}
    .stat-card::before {{
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 3px;
      background: transparent;
    }}
    .stat-card.emerald::before {{ background: var(--primary); }}
    .stat-card.gold::before {{ background: var(--gold); }}
    .stat-card.blue::before {{ background: var(--blue); }}
    .stat-card.rose::before {{ background: var(--danger); }}
    
    .stat-label {{
      font-size: 12px;
      text-transform: uppercase;
      letter-spacing: 0.8px;
      color: var(--text-muted);
      font-weight: 600;
    }}
    .stat-val {{
      font-size: 28px;
      font-weight: 800;
      margin: 8px 0 4px 0;
      display: flex;
      align-items: baseline;
      gap: 6px;
    }}
    .stat-sub {{
      font-size: 12px;
      color: var(--text-muted);
    }}

    /* Search & Filter Bar */
    .filter-bar {{
      background: var(--card-bg);
      border: 1px solid var(--card-border);
      border-radius: 14px;
      padding: 16px;
      margin-bottom: 20px;
      display: flex;
      flex-wrap: wrap;
      justify-content: space-between;
      align-items: center;
      gap: 14px;
    }}
    .search-box {{
      position: relative;
      flex: 1;
      min-width: 260px;
    }}
    .search-input {{
      width: 100%;
      padding: 11px 16px 11px 40px;
      background: #0d131f;
      border: 1px solid var(--card-border);
      border-radius: 10px;
      color: white;
      font-size: 13.5px;
      outline: none;
      transition: border-color 0.2s;
    }}
    .search-input:focus {{
      border-color: var(--primary);
      box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.15);
    }}
    .search-icon {{
      position: absolute;
      left: 14px;
      top: 50%;
      transform: translateY(-50%);
      color: var(--text-muted);
      font-size: 15px;
    }}
    .filter-pills {{
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
    }}
    .pill {{
      padding: 8px 14px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
      background: #1f2937;
      color: var(--text-muted);
      cursor: pointer;
      border: 1px solid transparent;
      transition: all 0.2s;
    }}
    .pill:hover {{
      color: white;
    }}
    .pill.active {{
      background: rgba(16, 185, 129, 0.15);
      color: var(--primary);
      border-color: rgba(16, 185, 129, 0.4);
    }}

    /* Data Table */
    .table-card {{
      background: var(--card-bg);
      border: 1px solid var(--card-border);
      border-radius: 14px;
      overflow: hidden;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
    }}
    table {{
      width: 100%;
      border-collapse: collapse;
      text-align: left;
      font-size: 13.5px;
    }}
    th {{
      background: #0d131f;
      padding: 14px 18px;
      font-weight: 700;
      color: var(--text-muted);
      font-size: 12px;
      text-transform: uppercase;
      letter-spacing: 0.6px;
      border-bottom: 1px solid var(--card-border);
    }}
    td {{
      padding: 14px 18px;
      border-bottom: 1px solid #1f2937;
      vertical-align: middle;
    }}
    tr:last-child td {{
      border-bottom: none;
    }}
    tr:hover td {{
      background: rgba(255, 255, 255, 0.02);
    }}
    .nim-badge {{
      font-family: monospace;
      font-weight: 700;
      color: #93c5fd;
      background: rgba(59, 130, 246, 0.1);
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 12px;
      letter-spacing: 0.5px;
    }}
    .name-col {{
      font-weight: 600;
      color: #fff;
    }}
    .status-badge {{
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 5px 10px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 700;
    }}
    .status-badge.registered {{
      background: rgba(16, 185, 129, 0.15);
      color: #34d399;
      border: 1px solid rgba(16, 185, 129, 0.3);
    }}
    .status-badge.unregistered {{
      background: rgba(245, 158, 11, 0.15);
      color: #fbbf24;
      border: 1px solid rgba(245, 158, 11, 0.3);
    }}
    .pose-tags {{
      display: flex;
      gap: 4px;
      flex-wrap: wrap;
    }}
    .pose-tag {{
      font-size: 10.5px;
      padding: 2px 7px;
      background: #1f2937;
      border-radius: 4px;
      color: #cbd5e1;
      font-weight: 500;
    }}
    .att-badge {{
      padding: 4px 10px;
      border-radius: 8px;
      font-size: 12px;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 5px;
    }}
    .att-badge.present {{
      background: rgba(16, 185, 129, 0.18);
      color: #10b981;
    }}
    .att-badge.absent {{
      background: rgba(239, 68, 68, 0.12);
      color: #f87171;
    }}
    .att-badge.none {{
      background: #1f2937;
      color: var(--text-muted);
    }}

    /* Footer */
    .footer {{
      margin-top: 30px;
      text-align: center;
      color: var(--text-muted);
      font-size: 12px;
      padding-bottom: 20px;
    }}
  </style>
</head>
<body>
  <div class="container">
    <!-- Top Header -->
    <div class="header">
      <div class="title-group">
        <h1>
          <span>ABSAR</span>
          <span class="arabic">أَبْصَار</span>
        </h1>
        <p class="tagline">Next-Gen AI Vision Attendance • Dashboard Visual Data Santri & Wajah</p>
      </div>
      <div class="header-actions">
        <button class="btn btn-primary" onclick="window.location.reload();">🔄 Refresh Data</button>
        <button class="btn btn-outline" onclick="exportToCSV();">📥 Unduh CSV</button>
      </div>
    </div>

    <!-- Stat Cards -->
    <div class="stats-grid">
      <div class="stat-card blue">
        <div class="stat-label">Total Santri</div>
        <div class="stat-val">{data['total_students']} <span style="font-size: 14px; font-weight: normal; color: var(--text-muted);">Siswa</span></div>
        <div class="stat-sub">Terdaftar di Basis Data</div>
      </div>
      <div class="stat-card emerald">
        <div class="stat-label">Wajah Terdaftar (Siap Absen)</div>
        <div class="stat-val" style="color: #34d399;">{data['registered_count']} <span style="font-size: 14px; font-weight: normal; color: #10b981;">({data['reg_percent']}%)</span></div>
        <div class="stat-sub">Siap Dideteksi Kamera</div>
      </div>
      <div class="stat-card gold">
        <div class="stat-label">Belum Rekam Wajah</div>
        <div class="stat-val" style="color: #fbbf24;">{data['unregistered_count']} <span style="font-size: 14px; font-weight: normal; color: var(--text-muted);">Siswa</span></div>
        <div class="stat-sub">Menunggu Perekaman HP</div>
      </div>
      <div class="stat-card emerald">
        <div class="stat-label">Total Vektor Pose AI</div>
        <div class="stat-val" style="color: #6ee7b7;">{data['total_embeddings']} <span style="font-size: 14px; font-weight: normal; color: var(--text-muted);">Vektor</span></div>
        <div class="stat-sub">InsightFace 512-Dimensi</div>
      </div>
      <div class="stat-card blue">
        <div class="stat-label">Sesi 19 Nov (Hari Ini)</div>
        <div class="stat-val" style="color: #60a5fa;">{data['attended_count']} <span style="font-size: 14px; font-weight: normal; color: var(--text-muted);">Hadir</span></div>
        <div class="stat-sub">{sess_text}</div>
      </div>
    </div>

    <!-- Search & Filter Controls -->
    <div class="filter-bar">
      <div class="search-box">
        <span class="search-icon">🔍</span>
        <input type="text" id="searchInput" class="search-input" placeholder="Cari berdasarkan Nama atau NIM..." oninput="filterData()">
      </div>
      <div class="filter-pills">
        <div class="pill active" onclick="setFilter('all', this)">Semua Santri ({data['total_students']})</div>
        <div class="pill" onclick="setFilter('registered', this)">✅ Wajah Terdaftar ({data['registered_count']})</div>
        <div class="pill" onclick="setFilter('unregistered', this)">⏳ Belum Terdaftar ({data['unregistered_count']})</div>
        <div class="pill" onclick="setFilter('present', this)">🎯 Hadir Hari Ini ({data['attended_count']})</div>
      </div>
    </div>

    <!-- Table -->
    <div class="table-card">
      <table>
        <thead>
          <tr>
            <th style="width: 50px;">No</th>
            <th>NIM / NIS</th>
            <th>Nama Santri</th>
            <th>Status Wajah</th>
            <th>Pose Tersimpan (AI Vektor)</th>
            <th>Sesi 19 Nov (Presensi)</th>
          </tr>
        </thead>
        <tbody id="studentTableBody">
          <!-- Populated by JavaScript -->
        </tbody>
      </table>
    </div>

    <!-- Footer -->
    <div class="footer">
      ABSAR (أَبْصَار) • Satu Jepretan Kelas Tanpa Titip Absen • Terhubung ke Database presensi.db
    </div>
  </div>

  <script>
    const students = {students_json};
    let currentFilter = 'all';

    function renderTable(list) {{
      const tbody = document.getElementById('studentTableBody');
      tbody.innerHTML = '';

      if (list.length === 0) {{
        tbody.innerHTML = `<tr><td colspan="6" style="text-align: center; padding: 40px; color: var(--text-muted);">Tidak ada data santri yang cocok dengan pencarian / filter.</td></tr>`;
        return;
      }}

      list.forEach((s, idx) => {{
        const tr = document.createElement('tr');

        // Status badge
        const statusBadge = s.is_registered 
          ? `<span class="status-badge registered">✅ Terdaftar (${{s.pose_count}} Pose)</span>`
          : `<span class="status-badge unregistered">⏳ Belum Ada Wajah</span>`;

        // Poses chips
        let posesHtml = '<span style="color: var(--text-muted); font-size: 12px;">-</span>';
        if (s.poses && s.poses.length > 0) {{
          posesHtml = `<div class="pose-tags">` + s.poses.map(p => `<span class="pose-tag">${{p}}</span>`).join('') + `</div>`;
        }}

        // Attendance badge
        let attHtml = `<span class="att-badge none">-</span>`;
        if (s.att_status === 'hadir') {{
          const scoreText = s.att_score ? ` (${{s.att_score}}%)` : '';
          attHtml = `<span class="att-badge present">✅ Hadir${{scoreText}}</span>`;
        }} else if (s.att_status === 'tidak_hadir') {{
          attHtml = `<span class="att-badge absent">❌ Belum Hadir</span>`;
        }}

        tr.innerHTML = `
          <td style="color: var(--text-muted); font-weight: 600;">${{idx + 1}}</td>
          <td><span class="nim-badge">${{s.nim}}</span></td>
          <td class="name-col">${{s.name}}</td>
          <td>${{statusBadge}}</td>
          <td>${{posesHtml}}</td>
          <td>${{attHtml}}</td>
        `;
        tbody.appendChild(tr);
      }});
    }}

    function filterData() {{
      const query = document.getElementById('searchInput').value.toLowerCase().trim();
      
      const filtered = students.filter(s => {{
        // Match Search
        const matchSearch = s.name.toLowerCase().includes(query) || s.nim.includes(query);
        if (!matchSearch) return false;

        // Match Filter Pill
        if (currentFilter === 'registered') return s.is_registered;
        if (currentFilter === 'unregistered') return !s.is_registered;
        if (currentFilter === 'present') return s.att_status === 'hadir';
        return true;
      }});

      renderTable(filtered);
    }}

    function setFilter(type, el) {{
      currentFilter = type;
      document.querySelectorAll('.pill').forEach(p => p.classList.remove('active'));
      el.classList.add('active');
      filterData();
    }}

    function exportToCSV() {{
      let csv = "No,NIM,Nama,Status Wajah,Jumlah Pose,Pose,Status Presensi,Akurasi\\n";
      students.forEach((s, i) => {{
        const status = s.is_registered ? "Terdaftar" : "Belum";
        const poses = s.poses ? s.poses.join("; ") : "";
        const att = s.att_status || "";
        const score = s.att_score || "";
        csv += `"${{i+1}}","${{s.nim}}","${{s.name}}","${{status}}","${{s.pose_count}}","${{poses}}","${{att}}","${{score}}"\\n`;
      }});
      
      const blob = new Blob([csv], {{ type: 'text/csv;charset=utf-8;' }});
      const url = URL.createObjectURL(blob);
      const link = document.createElement("a");
      link.setAttribute("href", url);
      link.setAttribute("download", `Data_Santri_ABSAR_${{new Date().toISOString().slice(0,10)}}.csv`);
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    }}

    // Initial render
    renderTable(students);
  </script>
</body>
</html>
"""

    with open(HTML_PATH, "w", encoding="utf-8") as f:
        f.write(html_content)

def main():
    data = fetch_data()
    generate_html_dashboard(data)
    print_terminal_summary(data)
    try:
        webbrowser.open(f"file:///{HTML_PATH}")
    except Exception as e:
        print(f"Buka browser otomatis gagal: {e}. Anda bisa buka manual: {HTML_PATH}")

if __name__ == "__main__":
    main()
