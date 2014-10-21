User.all.each do |user|
  if user.admin.nil? 
    if Random.rand(2) > 0
      user.update_column(:admin, true)
    else
      user.update_column(:admin, false)
    end
  end
end