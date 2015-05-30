{
  :en  => { :i18n => { :pluralize => lambda { |n| n == 1 ? :one : :other } } },
  :pl  => { :i18n => { :pluralize => lambda { |n| n == 1 ? :one : (2..4).include?(n % 10) && !(12..14).include?(n % 100) && !(22..24).include?(n % 100) ? :few : :other } } },
}