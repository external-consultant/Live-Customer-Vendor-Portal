//T13751-NS
page 81321 API_UpdatePurchaseQuote
{
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiUpdatePurchaseQuote';
    DelayedInsert = true;
    EntityName = 'apiUpdatePurchaseQuote';
    EntitySetName = 'apiUpdatePurchaseQuotes';               //Make Sure First Char in Small Letter and don't use any special char or space
    PageType = API;
    MultipleNewLines = true;
    SourceTable = API_PurchHeaderDetailUpdate;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            { }
            part(apiUpdatePurchaseQuoteLine; API_UpdatePurchaseQuoteLine)
            {
                Caption = 'apiUpdatePurchaseQuoteLine';
                EntityName = 'apiUpdatePurchaseQuoteLine';
                EntitySetName = 'apiUpdatePurchaseQuoteLines';
            }
        }
    }
}
//T13751-NE