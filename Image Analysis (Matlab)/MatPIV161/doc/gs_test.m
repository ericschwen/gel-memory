% First some shortcuts for ghostscript directories
ghostDir = fullfile( matlabroot, 'sys', 'ghostscript' );
gs=(fullfile(ghostDir,'bin','win32','gs'));
psfiles = fullfile( ghostDir, 'ps_files', '');
fonts = fullfile( ghostDir, 'fonts', '');

% Source & target files
in=fullfile(pwd,'mpwoco.ps');
out=fullfile(pwd,'mpwoco.jpg');

% Call ghostscript ps -> jpeg
dos(['echo quit | "',gs,'" -q -dNOPAUSE -I"',psfiles,...
      '" -I"',fonts,'" -sDEVICE=jpeg -sOUTPUTFILE="',out,'" "',in,'"'])

% Call ghostscript ps -> pdf
out=fullfile(pwd,'logo.pdf');
dos(['echo quit | "',gs,'" -q -dNOPAUSE -I"',psfiles,...
      '" -I"',fonts,'" -sDEVICE=pdfwrite -sOUTPUTFILE="',out,'" "',in,'"'])