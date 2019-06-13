#!/bin/bash

# `sam build` updates the GraphQL Schema's 'DefinitionS3Location' and
# the GraphQL Resolver's 'RequestMappingTemplateS3Location' &
# 'ResponseMappingTemplateS3Location' properties to be relative to the
# template provided rather than from the --base-dir flag if provided

# This script will go through sam build's generated template file,
# update the paths and move the referenced files into the .aws-sam/build directory

# Update this if your template file name is not `template.yaml`
TEMPLATE=template.yaml

echo Fixing GraphQL Schema and Resolver filepaths...

sed -e 's/\.\.\/\.\.\/\.stackery\///g' -i.orig .aws-sam/build/$TEMPLATE
# Remove temp file
rm .aws-sam/build/$TEMPLATE.orig

echo Moving GraphQL Schema and Resolver files into .aws-sam/build
grep -E 'RequestMappingTemplateS3Location|ResponseMappingTemplateS3Location|DefinitionS3Location' .aws-sam/build/$TEMPLATE | sed -e 's/.*://g' | xargs -I {} dirname {} | xargs -I {} mkdir -p ".aws-sam/build/{}"
grep -E 'RequestMappingTemplateS3Location|ResponseMappingTemplateS3Location|DefinitionS3Location' .aws-sam/build/$TEMPLATE | sed -e 's/.*://g' | xargs -I {} cp ./{} .aws-sam/build/{}