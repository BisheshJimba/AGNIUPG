codeunit 25006015 "Picture Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text007: Label 'Import';
        Text009: Label 'Image files|*.bmp;*.emf;*.gif;*.ico;*.jpg;*.jpeg;*.png;*.tiff;*.wmf';

    [Scope('Internal')]
    procedure BLOBImport(var PictureRef: Record "25006060" temporary; Name: Text): Text
    var
        NVInStream: InStream;
        NVOutStream: OutStream;
        UploadResult: Boolean;
        ErrorMessage: Text;
    begin
        CLEARLASTERROR;
        // There is no way to check if NVInStream is null before using it after calling the
        // UPLOADINTOSTREAM therefore if result is false this is the only way we can throw the error.
        UploadResult := UPLOADINTOSTREAM(Text007, '', Text009, Name, NVInStream);
        IF UploadResult THEN BEGIN
            PictureRef.BLOB.CREATEOUTSTREAM(NVOutStream);
            COPYSTREAM(NVOutStream, NVInStream);
            PictureRef.MODIFY(TRUE);
            EXIT(Name);
        END ELSE
            PictureRef.MODIFY(TRUE);

        ErrorMessage := GETLASTERRORTEXT;
        IF ErrorMessage <> '' THEN
            ERROR(ErrorMessage);

        EXIT('');
    end;
}

