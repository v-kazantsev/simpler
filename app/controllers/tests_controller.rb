class TestsController < Simpler::Controller

  def index
    render plain: "Plain text response"
  end

  def create
  end

  def show
    render plain: "#{params[:id]}"
  end

end
