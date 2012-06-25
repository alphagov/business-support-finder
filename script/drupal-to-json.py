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

def extra_fields_for(con, item):
  cursor = con.cursor()
  query = "SELECT * FROM d6_content_type_bsf_scheme WHERE nid=%(nid)s AND vid=%(vid)s" % {"nid":item['nid'], "vid":item['vid']}
  cursor.execute(query)
  row = cursor.fetchone()
  if not row:
    return {}
  keys = [
    "contact_details", "eligibility", "long_description", "min_turnover", "max_turnover", "minimum_age", "maximum_age",
    "minimum_employees", "maximum_employees", "minimum_grant_value", "organiser", "short_description",
    "source_of_funding", "contact_details", "careline_email"
  ]
  result = dict([(key, row['field_bsf_%s_value' % key]) for key in keys])
  result['website_url'] = row['field_bsf_website_url']
  result['website_title'] = row['field_bsf_website_title']
  result['maximum_grant_value'] = row['field_bsf_maximum_grant_va_value']
  return result

con = MySQLdb.connect("localhost", "root", "", "bip_prod", cursorclass=DictCursor)

cursor = con.cursor()
cursor.execute("SELECT d6_node.vid, d6_node.nid, d6_node.title FROM d6_node JOIN d6_content_type_bsf_scheme on d6_node.nid=d6_content_type_bsf_scheme.nid")

for item in cursor.fetchall():
  print(json.dumps(dict({
          "title": item['title'],
          "business_stages": fetch_field_values(con, "business_stage", item),
          "business_types": map(fix_business_type, fetch_field_values(con, "business_type", item)),
          "purposes": fetch_field_values(con, "purpose", item),
          "support_types": fetch_field_values(con, "support_type", item),
          "business_sectors": fetch_field_values(con, "business_sector", item)
  }.items() + extra_fields_for(con, item).items())))
