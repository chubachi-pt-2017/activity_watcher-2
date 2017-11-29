names = ['産業技術大学院大学', 'グーグル']
name_ens = ['AIIT', 'Google']
descriptions = []
email_domains = ['aiit.ac.jp', 'gmail.com']

1.upto(names.length) do |n|
  University.create!(
    name: names[n - 1],
    name_en: name_ens[n - 1],
    description: descriptions[n - 1],
    email_domain: email_domains[n - 1]
  )
end