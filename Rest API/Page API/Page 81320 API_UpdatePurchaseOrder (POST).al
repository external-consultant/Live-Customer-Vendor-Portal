//T13751-NS
page 81320 API_UpdatePurchaseOrder
{
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiUpdatePurchaseOrder';
    DelayedInsert = true;
    EntityName = 'apiUpdatePurchaseOrder';
    EntitySetName = 'apiUpdatePurchaseOrders';               //Make Sure First Char in Small Letter and don't use any special char or space
    PageType = API;
    MultipleNewLines = true;
    SourceTable = API_PurchHeaderDetailUpdate;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {


                field(attachment; Attachmentbase64)
                {
                    Caption = 'Attachment';
                }
                field(AttachmentFileName; AttachmentFileName)
                {
                }
                field(AttachmentFileExtension; AttachmentFileExtension)
                {
                    trigger OnValidate()
                    var
                        SingleInstance_lCdu: Codeunit "INT Single Instance";
                    begin
                        If Attachmentbase64 <> '' then Begin
                            if AttachmentFileName = '' then
                                Error('AttachmentFileName should have a value');
                            If AttachmentFileExtension = AttachmentFileExtension::" " then
                                Error('AttachmentFileExtension should have a value');
                            SingleInstance_lCdu.Setbase64(Attachmentbase64, AttachmentFileName, AttachmentFileExtension);
                        end;
                    End;
                }
            }
            part(apiUpdatePurchaseOrderLine; API_UpdatePurchaseOrderLine)
            {
                Caption = 'apiUpdatePurchaseOrderLine';
                EntityName = 'apiUpdatePurchaseOrderLine';
                EntitySetName = 'apiUpdatePurchaseOrderLines';
            }
        }
    }
    var
        Attachmentbase64: Text;
        AttachmentFileName: Text[1000];
        AttachmentFileExtension: Enum "Document Attachment File Type";
}
//T13751-NE