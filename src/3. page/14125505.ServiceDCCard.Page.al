page 14125505 "Service DC Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = Table14125607;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No."; "Document No.")
                {
                    Editable = false;
                }
                field(VIN; VIN)
                {
                    Editable = false;
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Editable = false;
                }
            }
            group(Orders)
            {
                Editable = false;
                part(; 14125506)
                {
                    SubPageLink = Document No.=FIELD(Document No.);
                }
                part(; 14125507)
                {
                    SubPageLink = Document No.=FIELD(Document No.);
                }
            }
        }
        area(factboxes)
        {
            part(IncomingDocAttachFactBox; 193)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Upload File';
                ShowFilter = false;
                Visible = false;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = isVisible;

                trigger OnAction()
                begin
                    IF NOT CONFIRM('Do you want to post the document?', FALSE) THEN
                        EXIT;
                    //Rec.TESTFIELD();
                    IF Rec.Status = Rec.Status::Closed THEN BEGIN
                        MESSAGE('The documnet is alrady posted');
                        EXIT;
                    END;
                    Rec.Status := Rec.Status::Closed;
                    Rec.MODIFY;
                    MESSAGE('Document has been posted.');
                    CurrPage.CLOSE;
                end;
            }
            action(Upload)
            {
                Image = UpdateShipment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = isVisible;

                trigger OnAction()
                begin
                    IF Rec.Status = Rec.Status::Closed THEN
                        ERROR('You cannot upload once posted');
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
                    CALCFIELDS(File);
                    IF NOT File.HASVALUE THEN
                        ERROR('file does not exist');
                    IF NOT TempBlob.Blob.HASVALUE THEN
                        TempBlob.Blob := File;
                    DefaultFileName := Rec."Document No." + '.' + Ext;
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
                Visible = isVisible;

                trigger OnAction()
                begin
                    //DELETE;
                    CLEAR(Rec.File);
                    Rec.MODIFY;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        IncomingDocument: Record "130";
    begin
        HasIncomingDocument := IncomingDocument.PostedDocExists("Document No.", "Posting Date");
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    end;

    trigger OnOpenPage()
    begin
        getCurrentServiceLine(Rec."Document No.");
        CurrPage.UPDATE;

        IF (Rec.Status = Rec.Status::Open) OR (Rec.Status = Rec.Status::" ") THEN
            isVisible := TRUE;
    end;

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
    begin
        ClientFileName := '';
        CALCFIELDS(File);
        IF File.HASVALUE THEN
            ERROR('File already uploaded.Please delete.');
        FileName := FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, STRSUBSTNO(FileDialogTxt, FilterTxt), FilterTxt);
        File := TempBlob.Blob;
        IF STRPOS(FileName, '.') <> 0 THEN
            Ext := COPYSTR(FileName, STRPOS(FileName, '.') + 1, STRLEN(FileName));
        Rec.MODIFY(TRUE);
        MESSAGE('Success');
    end;
}

