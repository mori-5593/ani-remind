# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

# コントローラー自体のエントリーポイントをピン留め
pin "controllers", to: "controllers/index.js", preload: true
# ディレクトリ配下のコントローラーファイルをすべてピン留め
pin_all_from "app/javascript/controllers", under: "controllers"
