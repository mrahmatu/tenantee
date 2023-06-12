defmodule Tenantee.Cldr do
  use Cldr,
    locales: ["en"],
    default_locale: "en",
    providers: [Cldr.Number, Cldr.Calendar, Cldr.DateTime, Money]

  def format_date(date) do
    case Tenantee.Cldr.Date.to_string(date) do
      {:ok, formatted_date} -> formatted_date
      _error -> "Invalid date"
    end
  end
end
