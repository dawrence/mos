[
    "categories_seeds",
    "roles_seed",
    "roles_by_user",
    "kitchen_seed"
].each do |file|
    load Rails.root.join("db/#{file}.rb")
end