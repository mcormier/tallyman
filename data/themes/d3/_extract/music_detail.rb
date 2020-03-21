#
# <data>
#   <detail>
#     <svgname>albumspurchased</svgname>
#   </detail>
# </data>
#
#@data_file = @webRoot + 'music_detail.xml'


# Total CDs
# =========================
# select count(*) from music 
# where date(dayPurchased) >= date (strftime('%Y','now') || '-01-01') and media = 'CD';
#
#
# Used CDs (pre-loved)
# -------------------------
# select count(*) from music 
# where date(dayPurchased) >= date (strftime('%Y','now') || '-01-01') 
# and media = 'CD' and used = 1;
#
# New CDs
# -------------------------
# select count(*) from music 
# where date(dayPurchased) >= date (strftime('%Y','now') || '-01-01') 
# and media = 'CD' and used = 0;
#
#
#
# Total Vinyl
# =========================
# select count(*) from music 
# where date(dayPurchased) >= date (strftime('%Y','now') || '-01-01') and media = 'Vinyl';
#
# Used Vinyl
# -------------------------
# select count(*) from music 
# where date(dayPurchased) >= date (strftime('%Y','now') || '-01-01') 
# and media = 'Vinyl' and used = 1;
#
# New Vinyl
# -------------------------
# select count(*) from music 
# where date(dayPurchased) >= date (strftime('%Y','now') || '-01-01') 
# and media = 'Vinyl' and used = 0;
