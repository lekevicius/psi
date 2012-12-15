$.fn.extend
  radioClass: (c) -> $(this).addClass(c).siblings().removeClass(c).end()
