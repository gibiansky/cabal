-- DO NOT EDIT: change Makefile.in, and run ./mkGHCMakefile.sh
module Distribution.Simple.GHC.Makefile where {
makefileTemplate :: String; makefileTemplate=unlines
["# -----------------------------------------------------------------------------","# Makefile template starts here.","","GHC_OPTS += -i$(odir)","","# For adding options on the command-line","GHC_OPTS += $(EXTRA_HC_OPTS)","","HS_OBJS = $(patsubst %,$(odir)/%.$(osuf),$(subst .,/,$(modules)))","HS_IFS  = $(patsubst %,$(odir)/%.$(hisuf),$(subst .,/,$(modules)))","C_OBJS  = $(patsubst %.c,$(odir)/%.$(osuf),$(C_SRCS))","","ifeq \"$(way:%dyn=YES)\" \"YES\"","LIB = $(odir)/libHS$(package)$(_way:%_dyn=%)-ghc$(GHC_VERSION)$(soext)","else","LIB = $(odir)/libHS$(package)$(_way).a","endif","","RM = rm -f","","# Optionally include local customizations:","-include Makefile.local","","# Rules follow:","","MKSTUBOBJS = find $(odir) -name \"*_stub.$(osuf)\" -print","# HACK ^^^ we tried to use $(wildcard), but apparently it fails due to","# make using cached directory contents, or something.","","all :: $(odir)/.depend $(LIB)","","$(odir)/.depend : $(MAKEFILE)","\t$(GHC) -M $(GENERATE_DOT_DEPEND) $(foreach way,$(WAYS),-optdep-s -optdep$(way)) $(foreach obj,$(MKDEPENDHS_OBJ_SUFFICES),-osuf $(obj)) $(filter-out -split-objs, $(GHC_OPTS)) $(modules)","\tfor dir in $(sort $(foreach mod,$(HS_OBJS) $(C_OBJS),$(dir $(mod)))); do \\","\t\tif test ! -d $$dir; then mkdir -p $$dir; fi \\","\tdone","","include $(odir)/.depend","","ifeq \"$(way:%dyn=YES)\" \"YES\"","$(LIB) : $(HS_OBJS) $(C_OBJS)","\t@$(RM) $@","\t$(GHC) -shared -dynamic -o $@ $(C_OBJS) $(HS_OBJS) `$(MKSTUBOBJS)` $(LIB_LD_OPTS)","else","ifneq \"$(filter -split-objs, $(GHC_OPTS))\" \"\"","$(LIB) : $(HS_OBJS) $(C_OBJS)","\t@$(RM) $@","\t(echo $(C_OBJS) `$(MKSTUBOBJS)`; find $(patsubst %.$(osuf),%_split,$(HS_OBJS)) -name '*.$(way_)o' -print) | xargs $(AR) q $(EXTRA_AR_ARGS) $@","else","$(LIB) : $(HS_OBJS) $(C_OBJS)","\t@$(RM) $@","\techo $(C_OBJS) $(HS_OBJS) `$(MKSTUBOBJS)` | xargs $(AR) q $(EXTRA_AR_ARGS) $@","endif","endif","","ifneq \"$(GHCI_LIB)\" \"\"","ifeq \"$(way)\" \"\"","all ::  $(GHCI_LIB)","","$(GHCI_LIB) : $(HS_OBJS) $(C_OBJS)","\t@$(RM) $@","\t$(LD) -r -o $@ $(EXTRA_LD_OPTS) $(HS_OBJS) `$(MKSTUBOBJS)` $(C_OBJS)","endif","endif","","# suffix rules","","# The .hs files might be in $(odir) if they were preprocessed","$(odir_)%.$(osuf) : $(odir_)%.hs","\t$(GHC) $(GHC_OPTS) -c $< -o $@  -ohi $(basename $@).$(hisuf)","","$(odir_)%.$(osuf) : $(odir_)%.lhs","\t$(GHC) $(GHC_OPTS) -c $< -o $@  -ohi $(basename $@).$(hisuf)","","$(odir_)%.$(osuf) : %.c","\t@$(RM) $@","\t$(GHC) $(GHC_CC_OPTS) -c $< -o $@","","$(odir_)%.$(way_)s : %.c","\t@$(RM) $@","\t$(GHC) $(GHC_CC_OPTS) -S $< -o $@","","%.$(hisuf) : %.$(osuf)","\t@if [ ! -f $@ ] ; then \\","\t    echo Panic! $< exists, but $@ does not.; \\","\t    exit 1; \\","\telse exit 0 ; \\","\tfi","","%.$(way_)hi-boot : %.$(osuf)-boot","\t@if [ ! -f $@ ] ; then \\","\t    echo Panic! $< exists, but $@ does not.; \\","\t    exit 1; \\","\telse exit 0 ; \\","\tfi","","$(odir_)%.$(hisuf) : %.$(way_)hc","\t@if [ ! -f $@ ] ; then \\","\t    echo Panic! $< exists, but $@ does not.; \\","\t    exit 1; \\","\telse exit 0 ; \\","\tfi","","show:","\t@echo '$(VALUE)=\"$($(VALUE))\"'","","clean ::","\t$(RM) $(HS_OBJS) $(C_OBJS) $(LIB) $(GHCI_LIB) $(HS_IFS) .depend","\t$(RM) -rf $(wildcard $(patsubst %.$(osuf), %_split, $(HS_OBJS)))","\t$(RM) $(wildcard $(patsubst %.$(osuf), %.o-boot, $(HS_OBJS)))","\t$(RM) $(wildcard $(patsubst %.$(osuf), %.hi-boot, $(HS_OBJS)))","\t$(RM) $(wildcard $(patsubst %.$(osuf), %_stub.o, $(HS_OBJS)))","","ifneq \"$(strip $(WAYS))\" \"\"","ifeq \"$(way)\" \"\"","all clean ::","# Don't rely on -e working, instead we check exit return codes from sub-makes.","\t@case '${MFLAGS}' in *-[ik]*) x_on_err=0;; *-r*[ik]*) x_on_err=0;; *) x_on_err=1;; esac; \\","\tfor i in $(WAYS) ; do \\","\t  echo \"== $(MAKE) way=$$i -f $(MAKEFILE) $@;\"; \\","\t  $(MAKE) way=$$i -f $(MAKEFILE) --no-print-directory $(MFLAGS) $@ ; \\","\t  if [ $$? -eq 0 ] ; then true; else exit $$x_on_err; fi; \\","\tdone","\t@echo \"== Finished recursively making \\`$@' for ways: $(WAYS) ...\"","endif","endif",""]
}
