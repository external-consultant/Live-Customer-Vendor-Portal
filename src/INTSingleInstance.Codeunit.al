codeunit 81240 "INT Single Instance"
{
    // version WebPortal

    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        AccountNumber: Code[20];
        UserNameGlob: Code[80];
        Attachmentbase64: Text;
        AttachmentFileName: Text[1000];
        AttachmentFileExtension: Enum "Document Attachment File Type";

    procedure SaveLogin(AccountCode: Code[20]; UserName: Code[80])
    begin
        AccountNumber := AccountCode;
        UserNameGlob := UserName;
    end;

    procedure GetAccountNo(): Code[20]
    begin
        exit(AccountNumber);
    end;

    procedure GetUserName(): Code[80]
    begin
        exit(UserNameGlob);
    end;
    //T13751-NS
    procedure Setbase64(Attachment_iTxt: Text; AttachmentFileName_iTxt: Text; AttachmentFileExtension_iTxt: Enum "Document Attachment File Type")
    var
    Begin
        Clear(Attachmentbase64);
        Clear(AttachmentFileName);
        Clear(AttachmentFileExtension);
        Attachmentbase64 := Attachment_iTxt;
        AttachmentFileName := AttachmentFileName_iTxt;
        AttachmentFileExtension := AttachmentFileExtension_iTxt;
    End;

    procedure Getbase64(Var Attachment_vTxt: Text; Var AttachmentFileName_vTxt: Text; Var AttachmentFileExtension_vTxt: Enum "Document Attachment File Type")
    var
    Begin
        Attachment_vTxt := Attachmentbase64;
        AttachmentFileName_vTxt := AttachmentFileName;
        AttachmentFileExtension_vTxt := AttachmentFileExtension;
    End;
    //T13751-NE
}

