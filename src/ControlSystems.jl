module ControlSystems

export  LTISystem,
        AbstractStateSpace,
        StateSpace,
        HeteroStateSpace,
        TransferFunction,
        DelayLtiSystem,
        Continuous,
        Discrete,
        ss,
        tf,
        zpk,
        isproper,
        StaticStateSpace,
        to_static,
        to_sized,
        input_names,
        output_names,
        state_names,
        # Linear Algebra
        balance,
        balance_statespace,
        are,
        lqr,
        kalman,
        covar,
        norm,
        hinfnorm,
        linfnorm,
        gram,
        grampd,
        ctrb,
        obsv,
        place,
        # Model Simplification
        reduce_sys,
        sminreal,
        minreal,
        balreal,
        baltrunc,
        similarity_transform,
        time_scale,
        innovation_form,
        observer_predictor,
        observer_controller,
        # Stability Analysis
        isstable,
        poles,
        tzeros,
        dcgain,
        zpkdata,
        damp,
        dampreport,
        markovparam,
        margin,
        delaymargin,
        gangoffour,
        relative_gain_array,
        # Connections
        append,
        series,
        parallel,
        array2mimo,
        feedback,
        feedback2dof,
        starprod,
        lft,
        sensitivity,
        input_sensitivity,
        output_sensitivity,
        comp_sensitivity,
        input_comp_sensitivity,
        output_comp_sensitivity,
        G_PS,
        G_CS,
        # Discrete
        c2d,
        c2d_x0map,
        d2c,
        # Time Response
        step,
        impulse,
        lsim,
        lsim!,
        LsimWorkspace,
        solve,
        Simulator,
        # Frequency Response
        freqresp, freqrespv, freqresp!,
        evalfr,
        bode, bodev,
        bodemag!,
        BodemagWorkspace,
        nyquist, nyquistv,
        sigma, sigmav,
        # delay systems
        delay,
        pade,
        nonlinearity,
        # demo systems
        ssrand,
        DemoSystems, # A module containing some example systems
        # utilities
        num,    #Deprecated
        den,    #Deprecated
        numvec,
        denvec,
        numpoly,
        denpoly,
        iscontinuous,
        isdiscrete,
        ssdata,
        add_input,
        add_output


# QUESTION: are these used? LaTeXStrings, Requires, IterTools
using RecipesBase, LaTeXStrings, LinearAlgebra
import Polynomials
import Polynomials: Polynomial, coeffs
using OrdinaryDiffEq
import Base: +, -, *, /, (==), (!=), isapprox, convert, promote_op
import Base: getproperty, getindex
import Base: exp # for exp(-s)
import LinearAlgebra: BlasFloat
import Hungarian # For pole assignment in rlocusplot
export lyap # Make sure LinearAlgebra.lyap is available
import Printf
import DSP: conv
import DiffEqCallbacks: SavingCallback, SavedValues
using ForwardDiff
import MatrixPencils
using DelayDiffEq
using MacroTools
using MatrixEquations
using UUIDs # to load Plots in gangoffourplot
using StaticArrays, Polyester

abstract type AbstractSystem end


include("types/result_types.jl")
include("types/TimeEvolution.jl")
## Added interface:
#   timeevol(Lti) -> TimeEvolution (not exported)


include("types/Lti.jl")

include("types/SisoTf.jl")

# Transfer functions and tranfer function elemements
include("types/TransferFunction.jl")
include("types/SisoTfTypes/SisoZpk.jl")
include("types/SisoTfTypes/SisoRational.jl")
include("types/SisoTfTypes/promotion.jl")
include("types/SisoTfTypes/conversion.jl")

include("types/StateSpace.jl")

# TODO Sample time
include("types/PartitionedStateSpace.jl")
include("types/LFTSystem.jl")
include("types/DelayLtiSystem.jl")
include("types/HammersteinWiener.jl")

# Convenience constructors
include("types/tf.jl")
include("types/zpk.jl")

include("utilities.jl")

include("types/promotion.jl")
include("types/conversion.jl")
include("connections.jl")
include("sensitivity_functions.jl")

# Analysis
include("freqresp.jl")
include("timeresp.jl")

include("matrix_comps.jl")
include("simplification.jl")

include("discrete.jl")
include("analysis.jl")
include("synthesis.jl")

include("simulators.jl")
include("pid_design.jl")

include("demo_systems.jl")

include("delay_systems.jl")
include("hammerstein_weiner.jl")
include("nonlinear_components.jl")

include("types/staticsystems.jl")

include("plotting.jl")

@deprecate pole poles
@deprecate tzero tzeros
@deprecate num numvec
@deprecate den denvec
@deprecate norminf hinfnorm
@deprecate diagonalize(s::AbstractStateSpace, digits) diagonalize(s::AbstractStateSpace)
@deprecate luenberger(sys, p) place(sys, p, :o)
@deprecate luenberger(A, C, p) place(A, C, p, :o)
# There are some deprecations in pid_control.jl for laglink/leadlink/leadlinkat

function covar(D::Union{AbstractMatrix,UniformScaling}, R)
    @warn "This call is deprecated due to ambiguity, use covar(ss(D), R) or covar(ss(D, Ts), R) instead"
    D*R*D'
end

# The path has to be evaluated upon initial import
const __CONTROLSYSTEMS_SOURCE_DIR__ = dirname(Base.source_path())

end
