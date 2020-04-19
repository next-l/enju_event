CSV.generate(col_sep: "\t", row_sep: "\r\n") do |csv|
  csv << %w(library name note start_at end_at)
  @event_import_results.each do |result|
    csv << result.body.split("\t")
  end
end
