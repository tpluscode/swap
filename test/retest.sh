#! /bin/bash
# $Id$
#   Regression test for new versions of cwm
#
# TODO: separate notation3 testing from cwm testing
#
#alias cwm=python ~/swap/cwm.py
# see also: changelog at end of file.
mkdir -p temp
mkdir -p diffs

function cwm_test () {
  case=$1; desc=$2
  shift; shift;
  args=$*
  echo
  echo Test $case: $desc

  echo Test    cwm $args
  # Hmm... this suggests a --nocomments flag on cwm  its -quiet
#  (python ../cwm.py $args | sed -e 's/^ *#.*//' | sed -e 's/\$[I]d:\$//g' > temp/$case) || echo CRASH $case
  (python ../cwm.py -quiet $args | sed -e 's/\$[I]d.*\$//g' > temp/$case) || echo CRASH $case
  diff -Bbwu ref/$case temp/$case >diffs/$case
  if [ -s diffs/$case ]; then echo FAIL: $case: less diffs/$case "############"; else echo Pass $case; fi
}

cwm_test animal.n3 "Parse a small RDF file, generate N3" -rdf animal.rdf -n3

cwm_test animal-1.rdf "Parse a small RDF file and regenerate RDF" -rdf animal.rdf

cwm_test reluri-1.rdf "test generation of relative URIs" reluri-1.n3 --rdf

cwm_test contexts-1.n3 "Parse and generate simple contexts" contexts.n3

cwm_test anon-prop-1.n3 "Parse and regen anonymous property" anon-prop.n3

cwm_test daml-ont.n3 "Convert some RDF/XML into RDF/N3" daml-pref.n3 -rdf daml-ont.rdf -n3

cwm_test strquot.n3 "N3 string quoting" -n3 strquot.n3

#oops... misleading test case name.
cwm_test equiv-syntax.n3 "conversion of N3 = to RDF" -n3 equiv-syntax.n3 -rdf

cwm_test lists-simple.n3 "parsing and generation of N3 list () syntax" -n3 lists-simple.n3

cwm_test lists-simple-1.rdf "conversion of N3 list () syntax to RDF" -n3 lists-simple.n3 -rdf

#exit 0 # Tim, please update the expected results (ref/*)
#       # of the rest of these tests. -- DWC
# Should work - tim

# The prefix file is to give cwm a hint for output. It saves hints across files.
# cwm_test daml-ont.n3 "Convert DAML schema into N3" daml-pref.n3 -rdf daml-ont.rdf -n3
# This seems to be a duplicate of a test above.

cwm_test daml-ex.n3 "Try the examples" daml-pref.n3 -rdf daml-ex.rdf -n3

cwm_test rules12-1.n3 "log:implies Rules - try one iteration first." rules12.n3 -rules

cwm_test rules12-n.n3 "log:implies rules, iterating" rules12.n3 -think

cwm_test rules13-1.n3 "log:implies rules more complex, with means, once" rules13.n3 -rules

cwm_test rules13-n.n3 "log:implies rules more complex, with means, many times" rules13.n3 -think

cwm_test schema1.n3 "Schema validity" daml-ex.n3 invalid-ex.n3 schema-rules.n3 -think

cwm_test schema2.n3 "Schema validity using filtering out essential output" daml-ex.n3 invalid-ex.n3 schema-rules.n3 -think -filter=schema-filter.n3

echo
echo "        Test builtins:"

cwm_test bi-t1.n3 "Simple use of log:includes" includes/t1.n3 -think

cwm_test bi-t2.n3 "Simple use of log:includes" includes/t2.n3 -think

cwm_test bi-t3.n3 "Simple use of log:includes" includes/t3.n3 -think

cwm_test bi-t4.n3 "Simple use of log:includes - negative test" includes/t4.n3 -think

# Drop this until/unless we have formulae compare (by internment?) .  The graph isomorphism prob.
#cwm_test bi-t5.n3 "Simple use of log:includes" includes/t5.n3 -think

cwm_test bi-t6.n3 "Simple use of log:includes" includes/t6.n3 -think

cwm_test bi-t7.n3 "Simple use of log:includes" includes/t7.n3 -think

cwm_test bi-t8.n3 "Simple use of string built-ins" includes/t8.n3 -think

cwm_test bi-t9.n3 "Filter event by date using strcmp BI's" includes/t9br.n3 -think

cwm_test bi-t10.n3 "log:resolvesTo and log:includes" includes/t10.n3 -think

cwm_test bi-t11.n3 "log:resolvesTo and log:includes - schema checking" includes/t11.n3 -think

cwm_test bi-quant.n3 "log:includes handling of univ./exist. quantifiers" includes/quantifiers.n3 -think

cwm_test bi-concat.n3 "Test string concatetnation built-in" includes/concat.n3 -think

cwm_test bi-uri-startswith.n3 "Dan's bug case with uri and startswith" includes/uri-startswith.n3 -think

cwm_test resolves-rdf.n3 "log:resolvesTo with RDF/xml syntax" resolves-rdf.n3 -think

cwm_test sameDan.n3 "dealing with multiple descriptions of the same thing using log:lessThan, log:uri, daml:equivalentTo" sameDan.n3 sameThing.n3 --think --apply=forgetDups.n3 --purge

cwm_test smush.rdf "Data aggregation challenge from Jan 2001" --rdf smush-examples.rdf --n3 smush-schema.n3 sameThing.n3 --think --apply=forgetDups.n3 --purge --filter=smush-query.n3 --rdf

TEST_PARAMETER_1=TEST_VALUE_1; export TEST_PARAMETER_1 
cwm_test environ.n3 "Read operating system environment variable" os/environ.n3 -think


# $Log$
# Revision 1.22  2001-11-19 15:25:16  timbl
# quantifiers
#
# Revision 1.21  2001/11/15 22:11:24  timbl
# --string added, list output bugs fixed, quotation choices changed on output, log:includes hudes handles quantified variables better
#
# Revision 1.20  2001/09/19 19:14:28  timbl
# new schemas for builtins etc
#
# Revision 1.19  2001/09/17 02:59:32  timbl
# split up
#
# Revision 1.18  2001/09/07 02:07:52  timbl
# string.concatenation
#
# Revision 1.17  2001/08/30 21:29:16  connolly
# resolves-rdf.n3 case
#
# Revision 1.16  2001/08/27 12:45:57  timbl
# Runs most of retest, not all builtins. List handling started but not tested.
#
# Revision 1.15  2001/08/09 21:38:09  timbl
# See cwm.py log
#
# Revision 1.14  2001/07/20 16:21:59  connolly
# split smush-query out of smush-schema; added expected results, entry in retest.sh
#
# Revision 1.13  2001/07/19 16:56:00  connolly
# whoohoo! node merging works!
#
# Revision 1.12  2001/06/25 06:35:51  connolly
# fixed some bugs in def relativeURI(base, uri):
#
# Revision 1.11  2001/06/13 23:58:48  timbl
# Fixed bug in log:includes that bindings were not taken into target of includes
#
# Revision 1.10  2001/05/30 22:03:40  timbl
# mmm
#
# Revision 1.9  2001/05/21 14:35:47  connolly
# sorted @prefix directives by prefix on output
#
# Revision 1.8  2001/05/21 13:04:02  timbl
# version field expansion deletion was expanded -- now fixed
#
# Revision 1.7  2001/05/21 11:27:48  timbl
# Ids stripped
#
# Revision 1.5  2001/05/10 06:04:23  connolly
# remove more Id stuff
#
# Revision 1.4  2001/05/09 15:06:36  connolly
# fixed string parsing, updated DAML+OIL namespace; added tests for string parsing and bits of N3 syntax that depend on the choice of DAML namespace
#
# Revision 1.3  2001/05/08 05:37:46  connolly
# factored out common parts of retest.sh; got two test cases working. don't grok the rest.
#
