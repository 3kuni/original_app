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
        text.insert(len/2, "<br>")
        text.scan(/^.{#{len+4}}/m)[0] + "…"

      end
    else
      ''
    end
  end

end
