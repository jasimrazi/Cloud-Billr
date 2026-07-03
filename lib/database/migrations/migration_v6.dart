const String migrationV6 = '''
CREATE TABLE invoice_template_configs (
  id TEXT PRIMARY KEY,
  invoice_number_format TEXT NOT NULL DEFAULT 'INV-{YEAR}-{SEQ}',
  invoice_number_start_at INTEGER NOT NULL DEFAULT 1,
  currency TEXT NOT NULL DEFAULT 'USD',
  currency_symbol TEXT NOT NULL DEFAULT '\$',
  tax_enabled INTEGER NOT NULL DEFAULT 1,
  tax_label TEXT NOT NULL DEFAULT 'Tax',
  tax_rate REAL NOT NULL DEFAULT 0.0,
  tax_is_inclusive INTEGER NOT NULL DEFAULT 0,
  discount_enabled INTEGER NOT NULL DEFAULT 0,
  discount_type TEXT NOT NULL DEFAULT 'percentage',
  shipping_enabled INTEGER NOT NULL DEFAULT 0,
  shipping_label TEXT NOT NULL DEFAULT 'Shipping & Handling',
  due_date_type TEXT NOT NULL DEFAULT 'net_days',
  net_days INTEGER NOT NULL DEFAULT 30,
  show_notes_field INTEGER NOT NULL DEFAULT 1,
  show_terms_field INTEGER NOT NULL DEFAULT 1,
  default_notes TEXT NOT NULL DEFAULT '',
  default_terms TEXT NOT NULL DEFAULT '',
  line_item_columns TEXT NOT NULL DEFAULT '[]'
);
''';
