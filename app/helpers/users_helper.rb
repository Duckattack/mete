module UsersHelper
  def avatar(user)
    image_tag(user.avatar_url( :thumb ), { :width => 80 } )
  end

end
