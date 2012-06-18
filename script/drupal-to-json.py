# Export the Drupal database as JSON. One item per line and in the same format as the Mongoid model.
import MySQLdb
from MySQLdb.cursors import DictCursor
import json

def cap_first(word):
  return word[0].upper() + word[1:].lower()

def fix_business_type(item):
  if item == "Sole-trader":
    return "Sole trader"
  return item

def fetch_field_values(con, table, item):
  field = "field_bsf_%s_value" % table
  table = "d6_content_field_bsf_%s" % table
  cursor = con.cursor()
  query = "SELECT %(field)s FROM %(table)s WHERE nid=%(nid)s AND vid=%(vid)s" % {"field":field, "table":table, "vid":item['vid'], "nid":item['nid']}
  cursor.execute(query)
  return [cap_first(item[field]) for item in cursor.fetchall() if item[field]]

con = MySQLdb.connect("localhost", "root", "", "finance_finder", cursorclass=DictCursor)

cursor = con.cursor()
cursor.execute("SELECT vid, nid, title FROM d6_node")

for item in cursor.fetchall():
  print(json.dumps({
          "title": item['title'],
          "business_stages": fetch_field_values(con, "business_stage", item),
          "business_types": map(fix_business_type, fetch_field_values(con, "business_type", item)),
          "purposes": fetch_field_values(con, "purpose", item),
          "support_types": fetch_field_values(con, "support_type", item),
          "business_sectors": fetch_field_values(con, "business_sector", item)
  }))
