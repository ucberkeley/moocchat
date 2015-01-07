class ReportsController < ApplicationController
  def chatlog
  end

  def chatlog_show
    puts params
    @eventlog = EventLog.first
    puts @eventlog.methods

    respond_to do |format|
      format.html # 'chatlog_show.html.erb'
      format.json { render json: @eventlog }
    end
  end
end
