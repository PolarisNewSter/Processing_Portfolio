// ==========================
// Particleタブ
// 花火の「玉」や「粒」を表すクラス
// ==========================

class Particle {
  PVector pos;      // 現在位置
  PVector vel;      // 速度
  PVector acc;      // 加速度
  color col;        // 粒の色
  float lifespan = 255;  // 寿命（透明度に利用）
  boolean firework; // 打ち上げ玉かどうか
  boolean shaped = false;       // 形つき粒かどうか
  PVector baseOffset = new PVector(0, 0); // 形の相対位置
  float scaleFactor = 1;        // 拡大率

  // 打ち上げ玉 or 通常粒
  Particle(float x, float y, boolean firework) {
    this.pos = new PVector(x, y);
    this.acc = new PVector(0, 0);
    this.firework = firework;
    this.shaped = false;
    if (firework) {
      this.vel = new PVector(0, -random(8, 12)); // 上向き初速
    } else {
      this.vel = PVector.random2D();
      this.vel.mult(random(2, 8));
    }
    this.col = color(int(random(100,256)), int(random(100,256)), int(random(100,256)));
  }

  // 形つき粒（星・ハートなど）
  Particle(float cx, float cy, float ox, float oy) {
    this.pos = new PVector(cx, cy);
    this.acc = new PVector(0, 0);
    this.firework = false;
    this.shaped = true;
    this.baseOffset = new PVector(ox, oy);
    this.vel = new PVector(0, 0);
    this.col = color(int(random(100,256)), int(random(100,256)), int(random(100,256)));
  }

  void applyForce(PVector force) {
    acc.add(force);
  }

  void expand() {  // 形つき粒を拡大
    if (shaped) {
      scaleFactor *= 1.01;
    }
  }

  void update() {
    vel.add(acc);
    pos.add(vel);
    if (!firework) {
      lifespan -= 2;
      if (!shaped) {
        vel.mult(0.98); // 減速で自然な感じに
      }
    }
    acc.mult(0);
  }

  void show() {
    noStroke();
    fill(col, lifespan);
    if (shaped) {
      float drawX = pos.x + baseOffset.x * scaleFactor;
      float drawY = pos.y + baseOffset.y * scaleFactor;
      ellipse(drawX, drawY, 6, 6);
    } else if (firework) {
      ellipse(pos.x, pos.y, 8, 8);
    } else {
      ellipse(pos.x, pos.y, 6, 6);
    }
  }

  boolean done() {
    return lifespan < 0;
  }
}
