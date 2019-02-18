defmodule EarmarkTagCloud.CLI do

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  @cli_options [:div_classes, :gamma, :scales]

  @args """
  usage:

     earmark_tag_cloud --help
     earmark_tag_cloud --version
     earmark_tag_cloud [ options... <file> ]

  convert file from Markdown to HTML.

     where options can be any of:
       --div-classes --gamma --scale 

  """


  defp parse_args(argv) do
    switches = [
      help: :boolean,
      version: :boolean
      ]
    aliases = [
      h: :help,
      v: :version
    ]

    parse = OptionParser.parse(argv, switches: switches, aliases: aliases)
    case  parse  do
      { [ {switch, true } ],  _, _ } -> switch
      { options, [ filename ],  _ }  -> {open_file(filename), options}
      { options, [ ],           _ }  -> {:stdio, options}
      _                              -> :help
    end
  end


  defp process(:help) do
    IO.puts(:stderr, @args)
    IO.puts(:stderr, option_related_help())
  end

  defp process(:version) do
    with {:ok, version} <- :application.get_key(:earmark_tag_cloud, :vsn), do:
      IO.puts( version )
  end

  defp process({io_device, _options}) do
    content = IO.stream(io_device, :line) |> Enum.to_list
    
    {:ok, html, errors} = Earmark.as_html(content, Earmark.Plugin.define(EarmarkTagCloud))

    Enum.each(errors, fn {type, ln, msg} ->
      IO.puts(:stderr, "#{type}: lnb: #{ln} #{msg}")
    end)
    IO.puts(html)
  end


  defp open_file(filename), do: io_device(File.open(filename, [:utf8]), filename)

  defp io_device({:ok, io_device}, _), do: io_device
  defp io_device({:error, reason}, filename) do
    IO.puts(:stderr, "#{filename}: #{:file.format_error(reason)}")
    exit(1)
  end

  defp option_related_help do
    @cli_options
    |> Enum.map(&specific_option_help/1)
    |> Enum.join("\n")
  end

  defp specific_option_help( option ) do
    "      --#{option} defaults to #{inspect(Map.get(%Earmark.Options{}, option))}"
  end

end
