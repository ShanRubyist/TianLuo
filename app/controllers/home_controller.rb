# frozen_string_literal: true
require_relative '../models/concerns/rss_list'

class HomeController < ApplicationController
  include RssReadable
  include GoodsReadable
  include RSSList

  def index
    # @rss_feeds_list = RssFeed.rss_feeds_list(current_user.id)
    # @goods_list = Good.goods_list(current_user.id, params['page'], params['per'])
    # @unread_count = UserRssFeedShip.where(user_id: current_user.id, unread: true).count
    @font_list = [
      "", "AR PL UKai CN", "AR PL UKai HK", "AR PL UKai TW MBE", "AR PL UKai TW", "AR PL UMing CN", "AR PL UMing HK", "AR PL UMing TW MBE", "AR PL UMing TW", "Alibaba Sans Black", "Alibaba Sans Heavy", "Alibaba Sans Light", "Alibaba Sans Medium", "Alibaba Sans", "Alibaba Sans", "Bitstream Charter", "Bitstream Charter", "Bitstream Charter", "Bitstream Charter", "Caladea", "Caladea", "Caladea", "Caladea", "Cantarell", "Cantarell", "Cantarell", "Cantarell", "Carlito", "Carlito", "Carlito", "Carlito", "Century Schoolbook L", "Century Schoolbook L", "Century Schoolbook L", "Century Schoolbook L", "Courier 10 Pitch", "Courier 10 Pitch", "Courier 10 Pitch", "Courier 10 Pitch", "DejaVu Math TeX Gyre", "DejaVu Sans Condensed", "DejaVu Sans Condensed", "DejaVu Sans Condensed", "DejaVu Sans Condensed", "DejaVu Sans Light", "DejaVu Sans Mono", "DejaVu Sans Mono", "DejaVu Sans Mono", "DejaVu Sans Mono", "DejaVu Sans", "DejaVu Sans", "DejaVu Sans", "DejaVu Sans", "DejaVu Serif Condensed", "DejaVu Serif Condensed", "DejaVu Serif Condensed", "DejaVu Serif Condensed", "DejaVu Serif", "DejaVu Serif", "DejaVu Serif", "DejaVu Serif", "Dingbats", "Droid Sans Fallback", "Gentium Basic", "Gentium Basic", "Gentium Basic", "Gentium Basic", "Gentium Book Basic", "Gentium Book Basic", "Gentium Book Basic", "Gentium Book Basic", "Gentium", "Gentium", "GentiumAlt", "GentiumAlt", "HappyZcool\\-2016", "HarmonyOS Sans Black", "HarmonyOS Sans Light", "HarmonyOS Sans Medium", "HarmonyOS Sans SC Black", "HarmonyOS Sans SC Light", "HarmonyOS Sans SC Medium", "HarmonyOS Sans SC Thin", "HarmonyOS Sans SC", "HarmonyOS Sans SC", "HarmonyOS Sans Thin", "HarmonyOS Sans", "HarmonyOS Sans", "Lato Black", "Lato Black", "Lato Hairline", "Lato Hairline", "Lato Heavy", "Lato Heavy", "Lato Light", "Lato Light", "Lato Medium", "Lato Medium", "Lato Semibold", "Lato Semibold", "Lato Thin", "Lato Thin", "Lato", "Lato", "Lato", "Lato", "Liberation Mono", "Liberation Mono", "Liberation Mono", "Liberation Mono", "Liberation Sans Narrow", "Liberation Sans Narrow", "Liberation Sans Narrow", "Liberation Sans Narrow", "Liberation Sans", "Liberation Sans", "Liberation Sans", "Liberation Sans", "Liberation Serif", "Liberation Serif", "Liberation Serif", "Liberation Serif", "Linux Biolinum Keyboard O", "Linux Biolinum O", "Linux Biolinum O", "Linux Biolinum O", "Linux Libertine Display O", "Linux Libertine Initials O", "Linux Libertine Mono O", "Linux Libertine O", "Linux Libertine O", "Linux Libertine O", "Linux Libertine O", "Linux Libertine O", "Linux Libertine O", "Nimbus Mono L", "Nimbus Mono L", "Nimbus Mono L", "Nimbus Mono L", "Nimbus Roman No9 L", "Nimbus Roman No9 L", "Nimbus Roman No9 L", "Nimbus Roman No9 L", "Nimbus Sans L", "Nimbus Sans L", "Nimbus Sans L", "Nimbus Sans L", "Nimbus Sans L", "Nimbus Sans L", "Nimbus Sans L", "Nimbus Sans L", "Noto Kufi Arabic", "Noto Kufi Arabic", "Noto Mono", "Noto Naskh Arabic UI", "Noto Naskh Arabic UI", "Noto Naskh Arabic", "Noto Naskh Arabic", "Noto Nastaliq Urdu", "Noto Sans Armenian", "Noto Sans Armenian", "Noto Sans Avestan", "Noto Sans Balinese", "Noto Sans Bamum", "Noto Sans Batak", "Noto Sans Bengali UI", "Noto Sans Bengali UI", "Noto Sans Bengali", "Noto Sans Bengali", "Noto Sans Brahmi", "Noto Sans Buginese", "Noto Sans Buhid", "Noto Sans CJK JP Black", "Noto Sans CJK JP Bold", "Noto Sans CJK JP DemiLight", "Noto Sans CJK JP Light", "Noto Sans CJK JP Medium", "Noto Sans CJK JP Regular", "Noto Sans CJK JP Thin", "Noto Sans CJK KR Black", "Noto Sans CJK KR Bold", "Noto Sans CJK KR DemiLight", "Noto Sans CJK KR Light", "Noto Sans CJK KR Medium", "Noto Sans CJK KR Regular", "Noto Sans CJK KR Thin", "Noto Sans CJK SC Black", "Noto Sans CJK SC Bold", "Noto Sans CJK SC DemiLight", "Noto Sans CJK SC Light", "Noto Sans CJK SC Medium", "Noto Sans CJK SC Regular", "Noto Sans CJK SC Thin", "Noto Sans CJK TC Black", "Noto Sans CJK TC Bold", "Noto Sans CJK TC DemiLight", "Noto Sans CJK TC Light", "Noto Sans CJK TC Medium", "Noto Sans CJK TC Regular", "Noto Sans CJK TC Thin", "Noto Sans Canadian Aboriginal", "Noto Sans Carian", "Noto Sans Cham", "Noto Sans Cham", "Noto Sans Cherokee", "Noto Sans Coptic", "Noto Sans Cuneiform", "Noto Sans Cypriot", "Noto Sans Deseret", "Noto Sans Devanagari UI", "Noto Sans Devanagari UI", "Noto Sans Devanagari", "Noto Sans Devanagari", "Noto Sans Egyptian Hieroglyphs", "Noto Sans Ethiopic", "Noto Sans Ethiopic", "Noto Sans Georgian", "Noto Sans Georgian", "Noto Sans Glagolitic", "Noto Sans Gothic", "Noto Sans Gujarati UI", "Noto Sans Gujarati UI", "Noto Sans Gujarati", "Noto Sans Gujarati", "Noto Sans Gurmukhi UI", "Noto Sans Gurmukhi UI", "Noto Sans Gurmukhi", "Noto Sans Gurmukhi", "Noto Sans Hanunoo", "Noto Sans Hebrew", "Noto Sans Hebrew", "Noto Sans Imperial Aramaic", "Noto Sans Inscriptional Pahlavi", "Noto Sans Inscriptional Parthian", "Noto Sans Javanese", "Noto Sans Kaithi", "Noto Sans Kannada UI", "Noto Sans Kannada UI", "Noto Sans Kannada", "Noto Sans Kannada", "Noto Sans Kayah Li", "Noto Sans Kharoshthi", "Noto Sans Khmer UI", "Noto Sans Khmer UI", "Noto Sans Khmer", "Noto Sans Khmer", "Noto Sans Lao UI", "Noto Sans Lao UI", "Noto Sans Lao", "Noto Sans Lao", "Noto Sans Lepcha", "Noto Sans Limbu", "Noto Sans Linear B", "Noto Sans Lisu", "Noto Sans Lycian", "Noto Sans Lydian", "Noto Sans Malayalam UI", "Noto Sans Malayalam UI", "Noto Sans Malayalam", "Noto Sans Malayalam", "Noto Sans Mandaic", "Noto Sans Meetei Mayek", "Noto Sans Mongolian", "Noto Sans Mono CJK JP Bold", "Noto Sans Mono CJK JP Regular", "Noto Sans Mono CJK KR Bold", "Noto Sans Mono CJK KR Regular", "Noto Sans Mono CJK SC Bold", "Noto Sans Mono CJK SC Regular", "Noto Sans Mono CJK TC Bold", "Noto Sans Mono CJK TC Regular", "Noto Sans Myanmar UI", "Noto Sans Myanmar UI", "Noto Sans Myanmar", "Noto Sans Myanmar", "Noto Sans NKo", "Noto Sans New Tai Lue", "Noto Sans Ogham", "Noto Sans Ol Chiki", "Noto Sans Old Italic", "Noto Sans Old Persian", "Noto Sans Old South Arabian", "Noto Sans Old Turkic", "Noto Sans Oriya UI", "Noto Sans Oriya UI", "Noto Sans Oriya", "Noto Sans Oriya", "Noto Sans Osmanya", "Noto Sans Phags Pa", "Noto Sans Phoenician", "Noto Sans Rejang", "Noto Sans Runic", "Noto Sans Samaritan", "Noto Sans Saurashtra", "Noto Sans Shavian", "Noto Sans Sinhala", "Noto Sans Sinhala", "Noto Sans Sundanese", "Noto Sans Syloti Nagri", "Noto Sans Symbols", "Noto Sans Syriac Eastern", "Noto Sans Syriac Estrangela", "Noto Sans Syriac Western", "Noto Sans Tagalog", "Noto Sans Tagbanwa", "Noto Sans Tai Le", "Noto Sans Tai Tham", "Noto Sans Tai Viet", "Noto Sans Tamil UI", "Noto Sans Tamil UI", "Noto Sans Tamil", "Noto Sans Tamil", "Noto Sans Telugu UI", "Noto Sans Telugu UI", "Noto Sans Telugu", "Noto Sans Telugu", "Noto Sans Thaana", "Noto Sans Thaana", "Noto Sans Thai UI", "Noto Sans Thai UI", "Noto Sans Thai", "Noto Sans Thai", "Noto Sans Tibetan", "Noto Sans Tibetan", "Noto Sans Tifinagh", "Noto Sans UI", "Noto Sans UI", "Noto Sans UI", "Noto Sans UI", "Noto Sans Ugaritic", "Noto Sans Vai", "Noto Sans Yi", "Noto Sans", "Noto Sans", "Noto Sans", "Noto Sans", "Noto Serif Armenian", "Noto Serif Armenian", "Noto Serif Bengali", "Noto Serif Bengali", "Noto Serif Devanagari", "Noto Serif Devanagari", "Noto Serif Georgian", "Noto Serif Georgian", "Noto Serif Gujarati", "Noto Serif Gujarati", "Noto Serif Kannada", "Noto Serif Kannada", "Noto Serif Khmer", "Noto Serif Khmer", "Noto Serif Lao", "Noto Serif Lao", "Noto Serif Malayalam", "Noto Serif Malayalam", "Noto Serif Tamil", "Noto Serif Tamil", "Noto Serif Telugu", "Noto Serif Telugu", "Noto Serif Thai", "Noto Serif Thai", "Noto Serif", "Noto Serif", "Noto Serif", "Noto Serif", "OPPOSans B", "OPPOSans H", "OPPOSans L", "OPPOSans M", "OPPOSans R", "OpenSymbol", "PangMenZhengDao", "PangMenZhengDao\\-Cu", "REEJI\\-ZhenyanGB2.0\\-GX", "Source Han Serif SC", "Source Han Serif SC", "Standard Symbols L", "TsangerFeiBai W01", "TsangerFeiBai W02", "TsangerFeiBai W03", "TsangerFeiBai W04", "TsangerFeiBai W05", "TsangerXWZ", "TsangerZhoukeZhengdabangshu", "URW Bookman L", "URW Bookman L", "URW Bookman L", "URW Bookman L", "URW Chancery L", "URW Gothic L", "URW Gothic L", "URW Gothic L", "URW Gothic L", "URW Palladio L", "URW Palladio L", "URW Palladio L", "URW Palladio L", "WenCang", "WenQuanYi Micro Hei Mono", "WenQuanYi Micro Hei", "WenQuanYi Zen Hei Mono", "WenQuanYi Zen Hei Sharp", "WenQuanYi Zen Hei", "XianErTi", "ZCOOL_KuHei", "ZhenyanGB", "xiaowei", "zcool\\-gdh", "zcoolqingkehuangyouti", "zcoolwenyiti", "仓耳与墨 W01", "仓 耳与墨 W02", "仓耳与墨 W03", "仓耳与墨 W04", "仓耳与墨 W05", "仓耳渔阳体 W01", "仓耳渔阳体 W01", "仓耳渔阳体 W02", "仓耳渔阳体 W02", "仓耳渔阳体 W03", "仓耳渔阳体 W03", "仓耳渔阳体 W04", "仓耳渔阳体 W04", "仓耳渔阳体 W05", "仓耳渔阳体 W05", "仓耳舒圆体 W01", "仓耳舒圆体 W02", "仓耳舒圆体 W03", "仓耳舒圆体 W04", "仓耳舒圆体 W05", "思源宋体 ExtraLight", "思源 宋体 Heavy", "思源宋体 Light", "思源宋体 Medium", "思源宋体 SemiBold", "锐字潮牌真言简2.0免费 准粗", "锐字潮牌真言简2.0 免费 大粗", "锐字潮牌真言简2.0免费 常规", "锐字潮牌真言简2.0免费 特粗", "锐字潮牌真言简2.0免费 细体", "锐字潮牌真言简2.0免费 超粗"
    ]

    per ||= 200
    params['page'] ||= 1

    render_view_for_device '/home/index'
  end
end
