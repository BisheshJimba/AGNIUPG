page 50057 "Vendor Lines"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = Table130416;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vendor Code"; "Vendor Code")
                {
                }
                field("Vendor Name"; "Vendor Name")
                {
                }
                field("Quotes Amount"; "Quotes Amount")
                {
                }
                field("1st Nego. Amount"; "1st Nego. Amount")
                {
                }
                field("2nd Nego. Amount"; "2nd Nego. Amount")
                {
                }
                field("3rd Nego. Amount"; "3rd Nego. Amount")
                {
                }
                field(Description; Description)
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit Cost"; "Unit Cost")
                {

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                field(Amount; Amount)
                {

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field(Recommendation; Recommendation)
                {
                }
                field(Recommendation1; Recommendation1)
                {
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    Editable = true;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("G/L Account No."; "G/L Account No.")
                {
                }
                field("G/L Account Name"; "G/L Account Name")
                {
                }
                field(Selected; Selected)
                {
                }
                field("Incoming File Exist"; "Incoming File".HASVALUE)
                {
                    Editable = false;
                }
                field("Incoming File"; "Incoming File")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CLEAR(TempBlob);
                        CALCFIELDS("Incoming File");
                        IF NOT "Incoming File".HASVALUE THEN
                            ERROR('file does not exist');
                        IF NOT TempBlob.Blob.HASVALUE THEN
                            TempBlob.Blob := "Incoming File";
                        DefaultFileName := "Memo No." + '.' + Extension;
                        FileManagement.BLOBExport(TempBlob, DefaultFileName, TRUE);
                        MESSAGE('Downloaded');
                    end;
                }
                field(VIN; VIN)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                group("F&unctions")
                {
                    Caption = 'F&unctions';
                    Image = "Action";
                    action(Upload)
                    {

                        trigger OnAction()
                        begin
                            ImportFile;
                        end;
                    }
                    action(Open)
                    {
                        Caption = 'Open';

                        trigger OnAction()
                        var
                            DefaultFileName: Text;
                        begin
                            CLEAR(TempBlob);
                            CALCFIELDS("Incoming File");
                            IF NOT "Incoming File".HASVALUE THEN
                                ERROR('file does not exist');
                            IF NOT TempBlob.Blob.HASVALUE THEN
                                TempBlob.Blob := "Incoming File";
                            DefaultFileName := "Memo No." + '.' + Extension;
                            FileManagement.BLOBExport(TempBlob, DefaultFileName, TRUE);
                            MESSAGE('Downloaded');
                        end;
                    }
                    action(DeleteFiles)
                    {
                        Caption = 'Delete';

                        trigger OnAction()
                        begin
                            DELETE;
                        end;
                    }
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.UPDATE(TRUE);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //CurrPage.UPDATE(TRUE);
    end;

    var
        FileManagement: Codeunit "419";
        FileName: Text;
        ClientFileName: Text;
        TempBlob: Record "99008535";
        DefaultFileName: Text;

    local procedure ImportFile()
    var
        ImportTxt: Label 'Insert File';
        FileDialogTxt: Label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
        FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
    begin
        ClientFileName := '';
        CALCFIELDS("Incoming File");
        IF "Incoming File".HASVALUE THEN
            ERROR('File already uploaded.Please delete.');
        FileName := FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, STRSUBSTNO(FileDialogTxt, FilterTxt), FilterTxt);
        "Incoming File" := TempBlob.Blob;
        IF STRPOS(FileName, '.') <> 0 THEN
            Extension := COPYSTR(FileName, STRPOS(FileName, '.') + 1, STRLEN(FileName));
        Rec.MODIFY(TRUE);
        MESSAGE('Success');
    end;
}

