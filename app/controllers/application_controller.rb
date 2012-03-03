class ApplicationController < ActionController::Base
  protect_from_forgery
  FB = Hash.new
  FB[:id]='178597545526425'
  FB[:secret] = '0cd3653bbffe469b1ce99489d32b1e94'
end
