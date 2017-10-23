class Ps4Controller < ApplicationController
  def index
  end

  def download_pdf
      send_file("#{Rails.root}/public/outputs/Calendarize.pdf",
    filename: "Calendarize.pdf",
    type: "application/pdf"
  )
  end

  def statemodel_pdf
      send_file("#{Rails.root}/public/outputs/Calendarize_SD.pdf",
    filename: "Calendarize_SD.pdf",
    type: "application/pdf"
  )
  end
end
