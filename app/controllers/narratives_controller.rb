class NarrativesController < ApplicationController

  before_action :load_narrative, only: [:show, :update]

  include ActionController::Live

  respond_to :js, :html

  def index
  end

  def show
  end

  def new
    @narrative = Narrative.create
    redirect_to @narrative
  end

  def update
    attributes = params.require(:narrative).permit(:content)
    @narrative.content = "#{@narrative.content} #{attributes[:content]}"
    @narrative.save
    $redis.publish("narrative.update.#{@narrative.id}", @narrative.to_json)
  end

  def events
    narrative = Narrative.find(params[:narrative_id])
    response.headers["Content-Type"] = "text/event-stream"
    redis = Redis.new
    redis.subscribe("narrative.update.#{narrative.id}") do |on|
      on.message do |event, data|
        response.stream.write("event: narrative.update\n")
        response.stream.write("data: #{data}\n\n")
      end
    end
  rescue IOError
    logger.info "Stream closed"
  ensure
    redis.quit
    response.stream.close
  end

  private

  def load_narrative
    @narrative = Narrative.find(params[:id])
  end
end