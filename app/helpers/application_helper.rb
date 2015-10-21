module ApplicationHelper

  # 字数制限をつける
  # 引数 =>
  # text:カットしたい対象の文字列
  # len:字数
  
  def cut_off(text, len)
    if text != nil
      if text.length < len
        text
      else
        text.scan(/^.{#{len}}/m)[0] + "…"
      end
    else
      ''
    end
  end

end
