// ==========================
// Soundタブ
// 爆発音を鳴らす処理まとめ
// ==========================

SoundFile explosionSound;  // 爆発音を保持する変数（グローバル）

void initSound(PApplet app) { 
  // explosion.mp3 を dataフォルダに入れておく必要あり
  explosionSound = new SoundFile(app, "explosion.mp3");
}

void playExplosionSound() { 
  if (explosionSound != null) {
    explosionSound.play();
  }
}
