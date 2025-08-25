class DiariesController < ApplicationController
  def index
    @diaries = Diary.includes(:user).order(created_at: :desc)
  end
end
