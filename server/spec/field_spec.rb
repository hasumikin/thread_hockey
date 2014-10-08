require 'pry'
require_relative '../lib/field'

describe Field do
  before { @field = Field.new }

  describe '#act_ball' do
    context 'ボールベクトル1,1' do
      before { @field.instance_variable_set(:@ball_vector, [1,1]) }
      context 'ボールが右の壁に衝突直前' do
        before do
          @field.ball = {x: Field::WIDTH - 2, y: 10}
          @field.send(:act_ball)
        end
        it { expect(@field.ball).to eq({x: Field::WIDTH - 3, y: 11}) }
        it { expect(@field.instance_variable_get :@event).to eq [[:hit_touchline]] }
      end
      context 'ボールが下のエンドラインに衝突直前' do
        before do
          @field.ball = {x: 5, y: Field::HEIGHT - 1}
          @field.p1_keeper = {pos: 10}
          @field.send(:act_ball)
        end
        it { expect(@field.ball).to eq({x: 6, y: Field::HEIGHT - 2}) }
        it { expect(@field.instance_variable_get :@event).to eq [[:hit_endline]] }
      end
      context 'ボールが右下の角に衝突直前' do
        before do
          @field.ball = {x: Field::WIDTH - 2, y: Field::HEIGHT - 1}
          @field.p1_keeper = {pos: 10}
          @field.send(:act_ball)
        end
        it { expect(@field.ball).to eq({x: Field::WIDTH - 3, y: Field::HEIGHT - 2}) }
        it { expect(@field.instance_variable_get :@event).to eq [[:hit_touchline, :hit_endline]] }
      end
      context 'ボールがp1キーパーに衝突直前' do
        before do
          @field.ball = {x: 10, y: Field::HEIGHT - 2}
          @field.p1_keeper = {pos: 10}
          @field.send(:act_ball)
        end
        it { expect(@field.ball).to eq({x: 11, y: Field::HEIGHT - 3}) }
        it { expect(@field.instance_variable_get :@event).to eq [:hit_p1] }
      end
    end
    context 'ボールベクトル-1,1' do
      before { @field.instance_variable_set(:@ball_vector, [-1,1]) }
      context 'ボールが左の壁に衝突直前' do
        before do
          @field.ball = {x: 1, y: 10}
          @field.send(:act_ball)
        end
        it { expect(@field.ball).to eq({x: 2, y: 11}) }
        it { expect(@field.instance_variable_get :@event).to eq [[:hit_touchline]] }
      end
      context 'ボールが左下の角に衝突直前' do
        before do
          @field.ball = {x: 1, y: Field::HEIGHT - 1}
          @field.p1_keeper = {pos: 10}
          @field.send(:act_ball)
        end
        it { expect(@field.ball).to eq({x: 2, y: Field::HEIGHT - 2}) }
        it { expect(@field.instance_variable_get :@event).to eq [[:hit_touchline, :hit_endline]] }
      end
      context 'ボールがp1キーパーに衝突直前' do
        before do
          @field.ball = {x: 14, y: Field::HEIGHT - 2}
          @field.p1_keeper = {pos: 10}
          @field.send(:act_ball)
        end
        it { expect(@field.ball).to eq({x: 13, y: Field::HEIGHT - 3}) }
        it { expect(@field.instance_variable_get :@event).to eq [:hit_p1] }
      end
    end
    context 'ボールベクトル1,-1' do
      before { @field.instance_variable_set(:@ball_vector, [1,-1]) }
      context 'ボールが右上の角に衝突直前' do
        before do
          @field.ball = {x: Field::WIDTH - 2, y: 1}
          @field.p1_keeper = {pos: 10}
          @field.send(:act_ball)
        end
        it { expect(@field.ball).to eq({x: Field::WIDTH - 3, y: 2}) }
        it { expect(@field.instance_variable_get :@event).to eq [[:hit_touchline, :hit_endline]] }
      end
      context 'ボールがp2キーパーに衝突直前' do
        before do
          @field.ball = {x: 14, y: 2}
          @field.p2_keeper = {pos: 10}
          @field.send(:act_ball)
        end
        it { expect(@field.ball).to eq({x: 15, y: 3}) }
        it { expect(@field.instance_variable_get :@event).to eq [:hit_p2] }
      end
    end
    context 'ボールベクトル-1,-1' do
      before { @field.instance_variable_set(:@ball_vector, [-1,-1]) }
      context 'ボールが左上の角に衝突直前' do
        before do
          @field.ball = {x: 1, y: 1}
          @field.p1_keeper = {pos: 10}
          @field.send(:act_ball)
        end
        it { expect(@field.ball).to eq({x: 2, y: 2}) }
        it { expect(@field.instance_variable_get :@event).to eq [[:hit_touchline, :hit_endline]] }
      end
      context 'ボールがp2キーパーに衝突直前' do
        before do
          @field.ball = {x: 11, y: 2}
          @field.p2_keeper = {pos: 10}
          @field.send(:act_ball)
        end
        it { expect(@field.ball).to eq({x: 10, y: 3}) }
        it { expect(@field.instance_variable_get :@event).to eq [:hit_p2] }
      end
    end
  end

end

