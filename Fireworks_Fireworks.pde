// ==========================
// Fireworkタブ
// 花火オブジェクト（打ち上げ→爆発→消滅）
// ==========================

class Firework {
  Particle firework;                         // 打ち上げ中の玉
  ArrayList<Particle> particles;             // 爆発後の粒たち
  boolean exploded = false;                  // 爆発済みかどうか
  float targetY;                             // 爆発する高さ（クリックしたy座標）
  String shape;                              // 花火の形："normal","star","heart","smile"

  Firework(float tx, float ty) {             // コンストラクタ
    firework = new Particle(tx, height, true); // 下から打ち上げ開始
    targetY = ty;                              // クリックした高さを記録
    particles = new ArrayList<Particle>();     // 爆発粒リスト
    
    // 3%の確率で特殊形状（星・ハート・スマイル）
    if (random(1) < 0.03) {                    
      float r = random(1);
      if (r < 0.33) shape = "star";
      else if (r < 0.66) shape = "heart";
      else shape = "smile";
    } else {
      shape = "normal";  // それ以外は普通の爆発
    }
  }

  void update() {
    if (!exploded) {                               // まだ爆発してないとき
      firework.applyForce(new PVector(0, -0.2));   // 上方向に力を加える
      firework.update();                           // 打ち上げ玉を更新
      if (firework.pos.y <= targetY) {             // 目標高度に達したら
        exploded = true;                           // 爆発フラグ
        explode();                                 // 爆発処理
      }
    }

    // 爆発粒の更新
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      if (!p.firework) {   // 打ち上げ玉ではない場合
        p.expand();        // 形つき粒なら拡大する
      }
      p.applyForce(new PVector(0, 0.15)); // 重力を加える
      p.update();
      if (p.done()) {
        particles.remove(i); // 寿命が尽きた粒を削除
      }
    }
  }

  void explode() {  // 爆発時に呼ばれる
    playExplosionSound(); // サウンドを再生
    
    if (shape.equals("normal")) {               // 通常爆発
      for (int i = 0; i < 150; i++) {
        particles.add(new Particle(firework.pos.x, firework.pos.y, false));
      }
    } else if (shape.equals("star")) {          // 星形
      int points = 5;
      float radius1 = 60;
      float radius2 = 25;
      for (int i = 0; i < points*2; i++) {
        float angle = TWO_PI * i / (points*2);
        float r = (i % 2 == 0) ? radius1 : radius2;
        float x = cos(angle) * r;
        float y = sin(angle) * r;
        particles.add(new Particle(firework.pos.x, firework.pos.y, x, y));
      }
    } else if (shape.equals("heart")) {         // ハート形
      for (float t = 0; t < TWO_PI; t += 0.1) {
        float x = 16 * pow(sin(t), 3);
        float y = -(13*cos(t) - 5*cos(2*t) - 2*cos(3*t) - cos(4*t));
        x *= 4; y *= 4;
        particles.add(new Particle(firework.pos.x, firework.pos.y, x, y));
      }
    } else if (shape.equals("smile")) {         // スマイル顔
      for (float a = 0; a < TWO_PI; a += 0.1) {
        float x = cos(a) * 60;
        float y = sin(a) * 60;
        particles.add(new Particle(firework.pos.x, firework.pos.y, x, y));
      }
      // 目と口
      particles.add(new Particle(firework.pos.x, firework.pos.y, -20, -20));
      particles.add(new Particle(firework.pos.x, firework.pos.y, 20, -20));
      for (float a = 0; a < PI; a += 0.1) {
        float x = cos(a) * 30;
        float y = sin(a) * 15 + 20;
        particles.add(new Particle(firework.pos.x, firework.pos.y, x, y));
      }
    }
  }

  void show() {
    if (!exploded) {
      firework.show();  // 打ち上げ玉
    }
    for (Particle p : particles) {
      p.show();  // 爆発粒
    }
  }

  boolean done() {
    return exploded && particles.isEmpty();  // 爆発が終わって全粒消えたらtrue
  }
}
