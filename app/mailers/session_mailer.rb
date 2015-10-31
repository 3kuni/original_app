class SessionMailer < ApplicationMailer

  def session_email(user, post)
    if Textbook.find_by(asin:post.textbook).present?
      @title = Textbook.find_by(asin:post.textbook).title
    else
      @title=post.textbook
    end 
    mail to: "3kuni@sclass.jp", subject: "#{user.nickname} がセッションを開始しました"
  end

end
