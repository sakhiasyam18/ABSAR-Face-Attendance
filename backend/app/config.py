from pathlib import Path
from pydantic_settings import BaseSettings

BACKEND_DIR = Path(__file__).resolve().parent.parent

class Settings(BaseSettings):
    db_path: str = str(BACKEND_DIR / "presensi.db")
    storage_dir: str = str(BACKEND_DIR / "storage")
    model_name: str = "buffalo_l"
    det_size: int = 1280
    min_det_score: float = 0.40
    max_image_side: int = 1920
    reg_min_det_score: float = 0.4
    reg_min_self_similarity: float = 0.30
    registration_photos: int = 5
    match_threshold: float = 0.40
    max_captures_per_session: int = 5
    max_students_per_class: int = 100
    max_import_rows: int = 200
    points_present: int = 10
    points_absent: int = -10
    max_upload_mb: int = 10

    class Config:
        env_file = ".env"

settings = Settings()