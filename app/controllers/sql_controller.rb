class SqlController < ApplicationController
  def sql
    authorize SQL

    begin
      @result = SQL.exec(params[:sql])

      respond_to do |format|
        format.js { render :sql }
      end
    rescue => e
      render :js => "alert(\"#{j(e.to_s)}\")"
    end
  end
end
