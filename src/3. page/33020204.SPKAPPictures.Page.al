page 33020204 "SP KAP Pictures"
{
    Caption = 'KAP Pictures';
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Picture';
    SourceTable = Table33020162;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Week No."; "Week No.")
                {
                }
                field("Picture Name"; "Picture Name")
                {
                }
                field("Picture Extension"; "Picture Extension")
                {
                    Editable = false;
                }
                field("Picture Exists"; "Picture Exists")
                {
                }
                field("Use In Report"; "Use In Report")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(ImportPicture)
            {
                Caption = 'Import';
                Image = Import;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Text33020142: Label 'Picture imported successfully!';
                begin
                    //Code open an browser and take the input file and saves in the database.
                    CurrPage.SETSELECTIONFILTER(Rec);

                    //gblFileName := gblRBAutoMngt.BLOBImport(gblBLOBRef,gblImportFromFile,gblImportFromFile = '');
                    gblFileName := gblRBAutoMngt.BLOBImport(gblBLOBRef, gblImportFromFile);
                    IF gblFileName <> '' THEN BEGIN
                        gblKAPPicture.RESET;
                        gblKAPPicture.SETRANGE("Sales Person Code", "Sales Person Code");
                        gblKAPPicture.SETRANGE(Year, Year);
                        gblKAPPicture.SETRANGE(Month, Month);
                        gblKAPPicture.SETRANGE("Week No.", "Week No.");
                        IF gblKAPPicture.FIND('-') THEN BEGIN
                            gblKAPPicture.Picture := gblBLOBRef.Blob;
                            gblKAPPicture."Picture Extension" := getFileExtension(gblFileName);
                            gblKAPPicture."Picture Exists" := TRUE;
                            gblKAPPicture.MODIFY;
                        END;
                        MESSAGE(Text33020142);
                    END;

                    RESET;
                end;
            }
            action(OpenPicture)
            {
                Caption = 'Open';
                Image = TeamSales;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //Exports picture to temporary location of operating system and shows the picture.
                    CALCFIELDS(Picture);
                    IF Picture.HASVALUE THEN BEGIN
                        gblFileName := TEMPORARYPATH + "Picture Name" + '.' + "Picture Extension";
                        gblExportToFile := Picture.EXPORT(gblFileName);
                        HYPERLINK(gblFileName);
                        //DeleteFile(gblFileName); //This does not work in RTC environment.
                    END ELSE
                        MESSAGE(Text33020149);
                end;
            }
            action(ExportPicture)
            {
                Caption = 'Export';
                Image = Export;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //Here file is exported to the specified location by the user.
                    CALCFIELDS(Picture);
                    IF Picture.HASVALUE THEN BEGIN
                        gblBLOBRef.Blob := Picture;
                        IF gblExportToFile = '' THEN BEGIN
                            gblFileFilter := "Picture Extension" + ' ';
                            gblFileFilter := gblFileFilter + '(*' + "Picture Extension" + ')|*.' + "Picture Extension";
                            gblFileName := "Sales Person Code" + '-' + FORMAT(Year) + '-' + FORMAT(Month) + '-' + FORMAT("Week No.") + '-' +
                            "Picture Name" + '.' + "Picture Extension";
                            //gblFileName := gblCommonDialogMgt.OpenFile(Text33020143,gblFileName,4,gblFileFilter,1); commented because code cannot be found
                            gblExportToFile := gblBLOBRef.Blob.EXPORT(gblFileName);
                            MESSAGE(Text33020145);
                        END;
                    END ELSE
                        MESSAGE(Text33020149);
                end;
            }
            separator()
            {
            }
            action(DeletePicture)
            {
                Caption = 'Delete';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //Code to delete Picture record.
                    gblConfirmDelete := DIALOG.CONFIRM(Text33020146, FALSE);

                    IF gblConfirmDelete THEN BEGIN
                        CurrPage.SETSELECTIONFILTER(Rec);
                        DELETE;
                        MESSAGE(Text33020150);
                    END ELSE
                        MESSAGE(Text33020147, USERID);

                    RESET;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Sales Person Code" := xRec."Sales Person Code";
        Year := xRec.Year;
        Month := xRec.Month;
    end;

    var
        gblRBAutoMngt: Codeunit "419";
        gblFileName: Text[250];
        gblBLOBRef: Record "99008535";
        gblImportFromFile: Text[250];
        gblKAPPicture: Record "33020162";
        gblName: Text[100];
        gblExportToFile: Text[250];
        gblExportedFile: File;
        gblConfirmDelete: Boolean;
        gblCommonDialogMgt: Codeunit "412";
        gblFileFilter: Text[250];
        gblTempPath: Text[250];
        Text33020142: Label '\Doc';
        Text33020143: Label 'Export picture?';
        Text33020144: Label 'All Files (*.*)|*.*';
        Text33020145: Label 'Picture saved!';
        Text33020146: Label 'Are you sure - Delete?';
        Text33020147: Label 'Deletion aborted by user - %1!';
        Text33020148: Label 'When you have finished working with a document, you should delete the associated temporary file. Please note that this will not delete the document.\\Do you want to delete the temporary file?';
        Text33020149: Label 'There are no KAP pictures for this prospect. Please upload and try again.';
        Text33020150: Label 'Deleted!';

    [Scope('Internal')]
    procedure DeleteFile(PrmFileName: Text[250]): Boolean
    var
        i: Integer;
    begin
        //Deletes file after certain time interval.
        IF PrmFileName = '' THEN
            EXIT(FALSE);

        IF NOT EXISTS(PrmFileName) THEN
            EXIT(TRUE);

        REPEAT
            SLEEP(500);
            i := i + 1;
        UNTIL ERASE(PrmFileName) OR (i = 25);
        EXIT(NOT EXISTS(PrmFileName));
    end;

    [Scope('Internal')]
    procedure getFileExtension(PrmFileName: Text[250]): Text[20]
    var
        i: Integer;
    begin
        //Retrieves imported file extension.
        i := STRLEN(PrmFileName);
        WHILE COPYSTR(PrmFileName, i, 1) <> '.' DO
            i := i - 1;
        EXIT(COPYSTR(PrmFileName, i + 1, STRLEN(PrmFileName) - i));
    end;
}

