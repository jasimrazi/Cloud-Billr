# PDF Generation & Custom Templates — Tasks

## Database & Schema
- [x] Add packages `pdf` and `printing` to dependencies
- [x] Create `migration_v8.dart` to support template indexes
- [x] Register migration v8 in `migrations.dart`
- [x] Add invoice items query/delete operations to `DatabaseHelper`

## Models & State
- [x] Define `InvoiceItemModel` inside `InvoiceModel`
- [x] Add templateIndex and items list to `InvoiceModel`
- [x] Add defaultTemplateIndex to `InvoiceTemplateConfig`
- [x] Update `CreateInvoiceProvider` to track selectedTemplateIndex
- [x] Update `InvoiceProvider` to persist items during db CRUD

## Views
- [x] Update `TemplatesScreen` to persist global default template
- [x] Wire up `TemplatePicker` to `CreateInvoiceProvider` selection
- [x] Create `PdfHelper` with 4 distinct monochrome styles and legacy fallbacks
- [x] Wire up "Export PDF" on `InvoiceDetailScreen`
- [x] Wire up "Export PDF" draft generator on `CreateInvoiceScreen`
- [x] Add dynamic "Items" presentation to `InvoiceDetailScreen`
- [x] Create `PdfPreviewScreen` and wire up real dynamic PDF preview from draft data

## Verification
- [x] flutter analyze → zero errors ✅
