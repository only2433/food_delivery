enum ViewPage
{
  HOME,
  POPULAR_DETAIL,
  RECOMMAND_DETAIL,
  CART,
  CART_DETAIL
}

extension ViewPageExtension on ViewPage
{
  String get getStringValue
  {
    switch(this)
    {
      case ViewPage.HOME:
        return "/";
      case ViewPage.POPULAR_DETAIL:
        return "/popular-food";
      case ViewPage.RECOMMAND_DETAIL:
        return "/recommend-food";
      case ViewPage.CART:
        return "/cart-page";
      case ViewPage.CART_DETAIL:
        return "/cart-page-detail";
      default:
        return "/";
    }
  }
}