page 33019862 "HR Attachment Subform"
{
    PageType = ListPart;
    SourceTable = Table33020334;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Code; Code)
                {
                }
                field(Attachment; Attachment)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Upload)
            {
                Image = UpdateShipment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    IF NOT CONFIRM('Do you want to upload file.', FALSE) THEN
                        EXIT;
                    ImportFile;
                end;
            }
            action(Download)
            {
                Caption = 'Download';
                Image = Open;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    DefaultFileName: Text;
                begin
                    CLEAR(TempBlob);
                    Rec.CALCFIELDS(Attachment);
                    IF NOT Rec.Attachment.HASVALUE THEN
                        ERROR('file does not exist');
                    IF NOT TempBlob.Blob.HASVALUE THEN
                        TempBlob.Blob := Rec.Attachment;
                    DefaultFileName := 'FILE-' + FORMAT(RANDOM(99999999)) + '.' + Ext;
                    FileManagement.BLOBExport(TempBlob, DefaultFileName, TRUE);
                    //MESSAGE('Downloaded');
                end;
            }
            action(DeleteFiles)
            {
                Caption = 'Delete';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    //DELETE;

                    CLEAR(Rec.Attachment);
                    Rec.MODIFY;
                    MESSAGE('Deleted.');
                end;
            }
        }
    }

    var
        FileManagement: Codeunit "419";
        FileName: Text;
        ClientFileName: Text;
        TempBlob: Record "99008535";
        DefaultFileName: Text;
        HasIncomingDocument: Boolean;
        Ext: Text;
        isVisible: Boolean;

    local procedure ImportFile()
    var
        ImportTxt: Label 'Insert File';
        FileDialogTxt: Label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
        FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
        HRAtt: Record "33020334";
    begin
        /*HRAtt.INIT;
        HRAtt."Entry No." := getLastEntryNo;
        HRAtt."No." := "No.";
        
        ClientFileName := '';
        HRAtt.CALCFIELDS(Attachment);
        IF HRAtt.Attachment.HASVALUE THEN
          ERROR('File already uploaded.Please delete.');
        FileName := FileManagement.BLOBImportWithFilter(TempBlob,ImportTxt,FileName,STRSUBSTNO(FileDialogTxt,FilterTxt),FilterTxt);
        HRAtt.Attachment := TempBlob.Blob;
        IF STRPOS(FileName,'.') <> 0 THEN
          Ext := COPYSTR(FileName,STRPOS(FileName,'.')+1,STRLEN(FileName));
        HRAtt.INSERT(TRUE);
        MESSAGE('Success');
        */

        ClientFileName := '';
        Rec.CALCFIELDS(Attachment);
        IF Rec.Attachment.HASVALUE THEN
            ERROR('File already uploaded.Please delete.');
        FileName := FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, STRSUBSTNO(FileDialogTxt, FilterTxt), FilterTxt);
        Rec.Attachment := TempBlob.Blob;
        IF STRPOS(FileName, '.') <> 0 THEN
            Ext := COPYSTR(FileName, STRPOS(FileName, '.') + 1, STRLEN(FileName));
        Rec.MODIFY(TRUE);
        MESSAGE('Success');

    end;

    local procedure getLastEntryNo(): Integer
    var
        HRAtt: Record "33020334";
    begin
        HRAtt.RESET;
        IF HRAtt.FINDLAST THEN
            EXIT(HRAtt."Entry No." + 1)
        ELSE
            EXIT(1);
    end;
}

