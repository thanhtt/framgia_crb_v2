module CreateNewObject
  private
  def create_place_when_add_location
    if params[:name].present?
      unless Place.existed_place? params[:name]
        new_place = Place.create(name: params[:name], user_id: current_user.id)
        params[:event][:place_id] = new_place.id.to_s
      end
    end
  end

  def create_user_when_add_attendee
    if params[:event][:attendees_attributes].present?
      params[:event][:attendees_attributes].each do |key, attendee|
        generated_password = Devise.friendly_token.first(8)
        unless User.existed_email? attendee["email"]
          new_user = User.create(email: attendee["email"],
            name: attendee["email"], password: :generated_password)
          params[:event][:attendees_attributes][key]["user_id"] =
            new_user.id.to_s
        end
      end
    end
  end
end
