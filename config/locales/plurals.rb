{
  en: { i18n: { pluralize: ->(n) { n == 1 ? :one : :other } } },
  pl: { i18n:
    { pluralize: lambda do |n|
      if n == 1
        return :one
      else
        if n == (2..4)
                .include?(n % 10) && !(12..14)
                                      .include?(n % 100) && !(22..24)
                                                             .include?(n % 100)
          return :few
        else
          return :other
        end
      end
    end
    } }
}
