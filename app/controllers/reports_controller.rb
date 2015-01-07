class ReportsController < ApplicationController
  def chatlog
  end

  def parse_datetime_picker_date(d)
    return DateTime.strptime(d, '%m/%d/%Y %l:%M %p')
  end

  def chatlog_show
    @eventlog = EventLog.where(created_at: parse_datetime_picker_date(params[:datetime_start])..parse_datetime_picker_date(params[:datetime_end]))

    respond_to do |format|
      format.html # 'chatlog_show.html.erb'
      format.json { render json: @eventlog }
    end
  end
end
