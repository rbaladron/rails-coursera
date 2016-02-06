class Entrant
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: "results"

  field :bib, as: :bib, type: Integer
  field :secs, as: :secs, type: Float
  field :o, as: :overall, type: Placing
  field :gender, as: :gender, type: Placing
  field :group, as: :group, type: Placing

  embeds_many :results, class_name: 'LegResult', order: [:"event.o".asc], after_add: :update_total
  embeds_one :race, class_name: 'RaceRef', autobuild: true
  embeds_one :racer, class_name: 'RacerInfo', as: :parent, autobuild: true

  delegate :first_name, :first_name=, to: :racer
  delegate :last_name, :last_name=, to: :racer
  delegate :gender, :gender=, to: :racer, prefix: "racer"
  delegate :birth_year, :birth_year=, to: :racer
  delegate :city, :city=, to: :racer
  delegate :state, :state=, to: :racer

  delegate :name, :name=, to: :race, prefix: "race"
  delegate :date, :date=, to: :race, prefix: "race"


  def overall_place
    overall.place if overall
  end
  def gender_place
    gender.place if gender
  end
  def group_name
    group.name if group
  end
  def group_place
    group.place if group
  end

  def the_race
    self.race.race
  end

  def update_total(result)
    if self.secs.nil?
      self.secs = result.secs
    else
      self.secs += result.secs
    end
  end

end
