defmodule Mate.Common.Message do

  def translate(msg) do
    Gettext.gettext(Mate.Gettext, msg)
  end

  
end