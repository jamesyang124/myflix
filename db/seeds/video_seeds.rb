# Modulize Video seeds data
module VideoSeeds
  def self.category_creation
    comedies = Category.create(name: 'Comedies')
    dramas = Category.create(name: 'Dramas')
    reality = Category.create(name: 'Reality')
  end

  def self.video_collection
    [ 
      {
        title: 'Inception',
        category: Category.where(name: 'Comedies').first,
        description: "Dom Cobb is a skilled thief, the absolute best in the dangerous art of extraction, stealing valuable secrets from deep within the subconscious during the dream state, when the mind is at its most vulnerable. Cobb's rare ability has made him a coveted player in this treacherous new world of corporate espionage, but it has also made him an international fugitive and cost him everything he has ever loved. Now Cobb is being offered a chance at redemption. One last job could give him his life back but only if he can accomplish the impossible-inception. Instead of the perfect heist, Cobb and his team of specialists have to pull off the reverse: their task is not to steal an idea but to plant one. If they succeed, it could be the perfect crime. But no amount of careful planning or expertise can prepare the team for the dangerous enemy that seems to predict their every move. An enemy that only Cobb could have seen coming."
      },
      {
        title: 'Lincoln',
        category: Category.where(name: 'Comedies').first,
        description: "Director Steven Spielberg takes on the towering legacy of Abraham Lincoln, focusing on his stewardship of the Union during the Civil War years. The biographical saga also reveals the conflicts within Lincoln's cabinet regarding the war and abolition."
      },
      {
        title: 'SouthPark',
        category: Category.where(name: 'Reality').first,
        description: "Woo! South Park!"
      },
      {
        title: 'Family Guy',
        category: Category.where(name: 'Dramas').first, 
        description: "Woo! family guy!"
      },
      {
        title: 'Monk',
        category: Category.where(name: 'Dramas').first, 
        description: "Woo! Monk!"
      }
    ]
  end
end