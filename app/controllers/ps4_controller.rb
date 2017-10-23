class Ps4Controller < ApplicationController
  def index
  end

  def download_pdf
      send_file("#{Rails.root}/public/outputs/Calendarize.pdf",
    filename: "Calendarize.pdf",
    type: "application/pdf"
  )
  end
end
