use strict;
use warnings;
use utf8;

package GraphViz2::Abstract::Node;

# ABSTRACT: Deal with nodes independent of a Graph

use GraphViz2::Abstract::Util::Constants;

our @CARP_NOT;

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

=cut

use Class::Tiny {
  URL           => NONE,
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
  showboxes     => 0,
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

=attr C<URL>

Default: L<< C<none>|GraphViz2::Abstract::Util::Constants/NONE >>

=attr C<area>

Default: C<1.0>

=attr C<color>

Default: C<"black">

=attr C<colorscheme>

Default: L<< C<"">|GraphViz2::Abstract::Util::Constants/EMPTY_STRING >>

=attr C<comment>

Default: L<< C<"">|GraphViz2::Abstract::Util::Constants/EMPTY_STRING >>

=attr C<distortion>

Default: C<0.0>

=attr C<fillcolor>

Default: C<"lightgrey">

=attr C<fixedsize>

Default: L<< C<false>|GraphViz2::Abstract::Util::Constants/FALSE >>

=attr C<fontcolor>

Default: C<"black">

=attr C<fontname>

Default: C<"Times-Roman">

=attr C<fontsize>

Default: C<14.0>

=attr C<gradientangle>

Default: L<< C<"">|GraphViz2::Abstract::Util::Constants/EMPTY_STRING >>

=attr C<group>

Default: L<< C<"">|GraphViz2::Abstract::Util::Constants/EMPTY_STRING >>

=attr C<height>

Default: C<0.5>

=attr C<href>

Default: L<< C<"">|GraphViz2::Abstract::Util::Constants/EMPTY_STRING >>

=attr C<id>

Default: L<< C<"">|GraphViz2::Abstract::Util::Constants/EMPTY_STRING >>

=attr C<image>

Default: L<< C<"">|GraphViz2::Abstract::Util::Constants/EMPTY_STRING >>

=attr C<imagescale>

Default: L<< C<false>|GraphViz2::Abstract::Util::Constants/FALSE >>  ( Yes, really! )

=attr C<label>

Default: C<"\\N"> ( Appears to be a magic value for GraphViz )

=attr C<labelloc>

Default: C<"c">

=attr C<layer>

Default: L<< C<"">|GraphViz2::Abstract::Util::Constants/EMPTY_STRING >>

=attr C<margin>

Default: L<< C<unknown>|GraphViz2::Abstract::Util::Constants/UNKNOWN >>  ( Due to being render device specific defaults )

=attr C<nojustify>

Default: L<< C<false>|GraphViz2::Abstract::Util::Constants/FALSE >>

=attr C<ordering>

Default: L<< C<"">|GraphViz2::Abstract::Util::Constants/EMPTY_STRING >>

=attr C<orientation>

Default: C<0.0>

=attr C<penwidth>

Default: C<1.0>

=attr C<peripheries>

Default: L<< C<unknown>|GraphViz2::Abstract::Util::Constants/UNKNOWN >>

=attr C<pos>

Default: L<< C<unknown>|GraphViz2::Abstract::Util::Constants/UNKNOWN >>

=attr C<rects>

Default: L<< C<unknown>|GraphViz2::Abstract::Util::Constants/UNKNOWN >>

=attr C<regular>

Default: L<< C<false>|GraphViz2::Abstract::Util::Constants/FALSE >>

=attr C<root>

Default: L<< C<false>|GraphViz2::Abstract::Util::Constants/FALSE >>

=attr C<samplepoints>

Default: L<< C<unknown>|GraphViz2::Abstract::Util::Constants/UNKNOWN >>

Reason: Dependent on render device.

=attr C<shape>

Default: C<"ellipse">

=attr C<shapefile>

Default: L<< C<"">|GraphViz2::Abstract::Util::Constants/EMPTY_STRING >>

=attr C<showboxes>

Default: C<0>

=attr C<sides>

Default: C<4>

=attr C<skew>

Default: C<0.0>

=attr C<sortv>

Default: C<0>

=attr C<style>

Default: L<< C<"">|GraphViz2::Abstract::Util::Constants/EMPTY_STRING >>

=attr C<target>

Default: L<< C<none>|GraphViz2::Abstract::Util::Constants/NONE >>

=attr C<tooltip>

Default: L<< C<"">|GraphViz2::Abstract::Util::Constants/EMPTY_STRING >>

=attr C<vertices>

Default: L<< C<unknown>|GraphViz2::Abstract::Util::Constants/UNKNOWN >>

=attr C<width>

Default: C<0.75>

=attr C<xlabel>

Default: L<< C<"">|GraphViz2::Abstract::Util::Constants/EMPTY_STRING >>

=attr C<xlp>

Default: L<< C<"">|GraphViz2::Abstract::Util::Constants/EMPTY_STRING >>

=attr C<z>

Default: C<0.0>

=cut

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

=method C<as_hash>

This method returns all the values of all properties that B<DIFFER> from the defaults.

e.g.

    Node->new( color => 'black' )->as_hash();

Will return an empty list, as the default color is normally black.

See also L<< how special constants work in|GraphViz2::Abstract::Util::Constants/CONSTANTS >>

=cut

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

=method C<as_canon_hash>

This method returns all the values of all properties, B<INCLUDING> defaults.

e.g.

    Node->new( color => 'black' )->as_canon_hash();

Will return a very large list containing all the properties that we know the default values for.

See also L<< how special constants work in|GraphViz2::Abstract::Util::Constants/CONSTANTS >>

=cut

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
