use strict;
use warnings;
use utf8;

package GraphViz2::Abstract::Node;
BEGIN {
  $GraphViz2::Abstract::Node::AUTHORITY = 'cpan:KENTNL';
}
{
  $GraphViz2::Abstract::Node::VERSION = '0.001000';
}

# ABSTRACT: Deal with nodes independent of a Graph

use constant FALSE        => q[false];
use constant EMPTY_STRING => q[];
use constant UNKNOWN      => \q[unknown];
use constant NONE         => \q[none];


use Class::Tiny {
  area          => 1.0,
  color         => 'black',
  colorscheme   => EMPTY_STRING,
  comment       => EMPTY_STRING,
  distortion    => 0.0,
  fillcolor     => 'lightgrey',
  fixedsize     => FALSE,
  fontcolor     => 'black',
  fontname      => 'Times-Roman',
  fontsize      => 14.0,
  gradientangle => EMPTY_STRING,
  group         => EMPTY_STRING,
  height        => 0.5,
  href          => EMPTY_STRING,
  id            => EMPTY_STRING,
  image         => EMPTY_STRING,
  imagescale    => FALSE,
  label         => q[\\N],
  labelloc      => q[c],
  layer         => EMPTY_STRING,
  margin        => UNKNOWN,
  nojustify     => FALSE,
  ordering      => EMPTY_STRING,
  orientation   => 0.0,
  penwidth      => 1.0,
  peripheries   => UNKNOWN,
  pos           => UNKNOWN,
  rects         => UNKNOWN,
  regular       => FALSE,
  root          => FALSE,
  samplepoints  => UNKNOWN,
  shape         => 'ellipse',
  shapefile     => EMPTY_STRING,
  sides         => 4,
  skew          => 0.0,
  sortv         => 0,
  style         => EMPTY_STRING,
  target        => NONE,
  tooltip       => EMPTY_STRING,
  vertices      => UNKNOWN,
  width         => 0.75,
  xlabel        => EMPTY_STRING,
  xlp           => EMPTY_STRING,
  z             => 0.0,
};


use Scalar::Util qw(blessed);
use Scalar::Util qw(refaddr);

sub _is_equal {
  my ( $self, $a_ref, $b_ref ) = @_;

  return   if defined $a_ref     and not defined $b_ref;
  return   if not defined $a_ref and defined $b_ref;
  return 1 if not defined $a_ref and not defined $b_ref;

  ## A and B are both defined.

  return if not ref $a_ref and ref $b_ref;
  return if ref $a_ref and not $b_ref;

  if ( not ref $a_ref and not ref $b_ref ) {
    return $a_ref eq $b_ref;
  }

  ##  A and B are both refs.
  return refaddr $a_ref eq refaddr $b_ref;
}

sub _is_magic {
  my ( $self, $value ) = @_;
  return if not defined $value;
  return if not ref $value;
  my $addr = refaddr $value;
  return 1 if $addr eq refaddr UNKNOWN;
  return 1 if $addr eq refaddr NONE;
  return;
}

sub _foreach_attr {
  my ( $self, $callback ) = @_;
  if ( not blessed($self) ) {
    require Carp;
    local @CARP_NOT = 'GraphViz2::Abstract::Node';
    Carp::croak('Can\'t call as_hash on a class');
  }
  my $class    = blessed($self);
  my @attrs    = Class::Tiny->get_all_attributes_for($class);
  my $defaults = Class::Tiny->get_all_attribute_defaults_for(__PACKAGE__);
  for my $attr (@attrs) {
    my $value       = $self->$attr();
    my $has_default = exists $defaults->{$attr};
    my $default;
    if ($has_default) {
      $default = $defaults->{$attr};
    }
    $callback->( $attr, $value, $has_default, $default );
  }
  return $self;
}


sub as_hash {
  my ($self) = @_;
  my %output;

  $self->_foreach_attr(
    sub {
      my ( $attr, $value, $has_default, $default ) = @_;
      if ( not $has_default ) {
        return if $self->_is_magic($value);
        $output{$attr} = $value;
        return;
      }
      return if $self->_is_equal( $value, $default );
      return if $self->_is_magic($value);
      $output{$attr} = $value;
    }
  );
  return \%output;
}


sub as_canon_hash {
  my ($self) = @_;
  my %output;
  $self->_foreach_attr(
    sub {
      my ( $attr, $value, $has_default, $default ) = @_;
      return if $self->_is_magic($value);
      $output{$attr} = $value;
    }
  );
  return \%output;

}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

GraphViz2::Abstract::Node - Deal with nodes independent of a Graph

=head1 VERSION

version 0.001000

=head1 SYNOPSIS

    use GraphViz2::Abstract::Node;

    my $node = GraphViz2::Abstract::Node->new(
            color =>  ... ,
            id    =>  ... ,
            label =>  ... ,
    );

    # Mutate $node

    $node->label("Asdft");

    my $fillcolor = $node->fillcolor(); # Knows that the fill color is light grey despite never setting it.

    # Later:

    $graph->add_node(%{ $node->as_hash }); # Adds only the data that is not the same as GraphViz's defaults
    $graph->add_node(%{ $node->as_canon_hash }); # Adds all the data, including hardcoded defaults

=head1 DESCRIPTION

Working with GraphViz2, I found myself frequently needing shared styles for things, and I often had trouble knowing
which fields were and weren't valid for given things, for instance: C<Nodes>.

Its reasonably straight forward to ask the question "What is the attribute C<foo> applicable to" using the GraphViz website,
but much harder to know "What are all the attributes applicable to C<foo>".

Let alone work with them in a user friendly way from code.

=head2 Naming Rationale

I tried to choose a name that was not so likely to threaten GraphViz2 if GraphViz2 wanted to make a different
variation of what I'm doing, but as part of GraphViz2 itself.

As such, I plan on a few C<::Abstract> things, that aim to be stepping stones for dealing with complex data independent of C<GraphViz2>,
but in such a way that they make importing that data into C<GraphViz2> easy.

=head1 METHODS

=head2 C<as_hash>

This method returns all the values of all properties that B<DIFFER> from the defaults.

e.g.

    Node->new( color => 'black' )->as_hash();

Will return an empty list, as the default color is normally black.

See note about L<< C<Special Values>|/SPECIAL VALUES >>

=head2 C<as_canon_hash>

This method returns all the values of all properties, B<INCLUDING> defaults.

e.g.

    Node->new( color => 'black' )->as_canon_hash();

Will return a very large list containing all the properties that we know the default values for.

See note about L<< C<Special Values>|/SPECIAL VALUES >>

=head1 ATTRIBUTES

=head2 C<area>

Default: C<1.0>

=head2 C<color>

Default: C<"black">

=head2 C<colorscheme>

Default: C<"">

=head2 C<comment>

Default: C<"">

=head2 C<distortion>

Default: C<0.0>

=head2 C<fillcolor>

Default: C<"lightgrey">

=head2 C<fixedsize>

Default: L<< C<false>|/false >>

=head2 C<fontcolor>

Default: C<"black">

=head2 C<fontname>

Default: C<"Times-Roman">

=head2 C<fontsize>

Default: C<14.0>

=head2 C<gradientangle>

Default: C<"">

=head2 C<group>

Default: C<"">

=head2 C<height>

Default: C<0.5>

=head2 C<href>

Default: C<"">

=head2 C<id>

Default: C<"">

=head2 C<image>

Default: C<"">

=head2 C<imagescale>

Default: L<< C<false>|/false >>  ( Yes, really! )

=head2 C<label>

Default: C<"\\N"> ( Appears to be a magic value for GraphViz )

=head2 C<labelloc>

Default: C<"c">

=head2 C<layer>

Default: C<"">

=head2 C<margin>

Default: L<< C<unknown>|/UNKNOWN >>  ( Due to being render device specific defaults )

=head2 C<nojustify>

Default: L<< C<false>|/false >>

=head2 C<ordering>

Default: C<"">

=head2 C<orientation>

Default: C<0.0>

=head2 C<penwidth>

Default: C<1.0>

=head2 C<peripheries>

Default: L<< C<unknown>|/UNKNOWN >>

=head2 C<pos>

Default: L<< C<unknown>|/UNKNOWN >>

=head2 C<rects>

Default: L<< C<unknown>|/UNKNOWN >>

=head2 C<regular>

Default: L<< C<false>|/false >>

=head2 C<root>

Default: L<< C<false>|/false >>

=head2 C<samplepoints>

Default: L<< C<unknown>|/UNKNOWN >>

Reason: Dependent on render device.

=head2 C<shape>

Default: C<"ellipse">

=head2 C<shapefile>

Default: C<"">

=head2 C<sides>

Default: C<4>

=head2 C<skew>

Default: C<0.0>

=head2 C<sortv>

Default: C<0>

=head2 C<style>

Default: C<"">

=head2 C<target>

Default: L<< C<none>|/NONE >>

=head2 C<tooltip>

Default: C<"">

=head2 C<vertices>

Default: L<< C<unknown>|/UNKNOWN >>

=head2 C<width>

Default: C<0.75>

=head2 C<xlabel>

Default: C<"">

=head2 C<xlp>

Default: C<"">

=head2 C<z>

Default: C<0.0>

=head1 SPECIAL VALUES

In the specification, on GraphViz.org, there are a number of special values
which represent a fundamental incompatibility with native Perl code.

=over 4

=item * C<false>

Where the specification shows C<false> as a default value, this module instead returns the string C<false>

This is because under the hood, GraphViz2 doesn't support values for attributes other than defined ones.

So its assumed that GraphViz, under the hood, interprets the string "false" the same as the boolean condition "false";

=item * C<NONE>

In the GraphViz docs, a few items have a default value specified as:

    <none>

This item was confusing in the specification, and it wasn't clear if it was some sort of magic string, or what.

Internally, we use a special value, a reference to a string "none" to represent this default.

For instance:

    my $v = Node->new()->target();

    ok( ref $v, 'target returned a ref' );
    is( ref $v, 'SCALAR', 'target returned a scalar ref' );
    is( ${ $v }, 'none', 'target returned a scalar ref of "none"' );

However, because its not known how to canonicalize such forms, those values are presently not returned by either C<as_hash> methods.

So as a result:

    my $v = Node->new( color => \"none" )->as_hash()

Will emit an empty hash. ( Despite "none" being different from the default ).

Also:

    my $v = Node->new( color => \"none" )->as_canon_hash()

Will not emit a value for C<color> in its output, which may have the undesirable effect of reverting to the default, C<black> once rendered.

=item C<UNKNOWN>

On the GraphViz documentations, there were quite a few fields where the defaults were simply not specified,
or their values were cryptic.

Internally, those fields have the default value of C<\"unknown">

Like C<"none">, those fields with those values will not be emitted during hash production.

=back

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
