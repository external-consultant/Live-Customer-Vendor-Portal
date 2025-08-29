//T09311-NS
page 81274 API_CompanyInfoLogo
{
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiCompanyLogo';
    DelayedInsert = true;
    EntityName = 'apiCompanyLogo';
    EntityCaption = 'apiCompanyLogo';
    EntitySetName = 'apiCompanyLogos';          //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiCompanyLogos';
    PageType = API;
    SourceTable = "Company Information";

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field(picture; Rec.Picture)
                {
                    Caption = 'Picture';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(name2; Rec."Name 2")
                {
                    Caption = 'Name 2';
                }
                field(CompanyLogo_gTxt; CompanyLogo_gTxt)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        CompanyInfo_lRec: Record "Company Information";
        InStr: InStream;
        Base64Convert: Codeunit "Base64 Convert";
    begin
        CompanyLogo_gTxt := '';
        IF CompanyInfo_lRec.GET() Then begin
            CompanyInfo_lRec.CalcFields(Picture);
            CompanyInfo_lRec."Picture".CreateInStream(InStr);
            CompanyLogo_gTxt := Base64Convert.ToBase64(InStr);
        end;


    end;

    var
        CompanyLogo_gTxt: Text;

}
//T09311-NE